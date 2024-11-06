class_name Ship extends Node2D

enum Status {UNDECIDED, APPROVED, REJECTED}
enum Type {SHUTTLE, FRIGATE, CRUISER}
enum Faction {VOID, OBUDU, ARGUS}
var max_distance: float = 300
var min_distance: float = 40
var scale_multiplier: float = 0.1

var distance: float = max_distance
var angle: float = 0
var speed: float = 20
var ship_name: String = 'Default Ship'
var status: Status = Status.UNDECIDED:
	set(value):
		if value == Status.APPROVED:
			modulate = Color.CHARTREUSE
			speed = abs(speed)
		if value == Status.REJECTED:
			modulate = Color.CRIMSON
			speed = abs(speed) * -1
		status = value
		Ui.update_ship_details()
		Shift.is_shift_over(self)
	get:
		return status
var type: Type:
	set(value):
		scale = Vector2(value + 1, value + 1) * scale_multiplier
		type = value
	get:
		return type
var faction: Faction

func _ready() -> void:
	ship_name = str(randi())
	type = Type.values().pick_random()
	faction = Faction.values().pick_random()

func _process(delta: float) -> void:
	if distance < min_distance:
		visit_starport()
		Shift.is_shift_over(self)
	if distance > max_distance:
		queue_free()
		Shift.is_shift_over(self)
	elif self != null:
		distance -= delta * speed
		position = Vector2(distance, 0).rotated(angle)

func visit_starport() -> void:
	var is_dangerous: bool = false
	for security_rule: Dictionary in Shift.security_rules:
		if (
			security_rule.faction == faction &&
			security_rule.type == type
		):
			is_dangerous = true
	if is_dangerous:
		var damage: int = 10 * (type + 1)
		Game.hit_points -= damage
		print('Dealt ' + str(damage) + ' damage')
	queue_free()
	

func _on_area_2d_input_event(
	_viewport: Node,
	event: InputEvent,
	_shape_idx: int
) -> void:
	if event is InputEventMouseButton \
	and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) \
	and (event as InputEventMouseButton).pressed:
		Ui.selected_ship = self

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("approve") && self == Ui.selected_ship:
		status = Status.APPROVED
	if event.is_action_pressed("reject") && self == Ui.selected_ship:
		status = Status.REJECTED
