class_name Ship extends Node2D

enum Status { UNDECIDED, APPROVED, REJECTED }
enum Type { SHUTTLE, FRIGATE, CRUISER }
enum Faction { VOID, OBUDU, ARGUS }
var max_distance: float = 300
var min_distance: float = 40
var scale_multiplier: float = 0.1

var distance: float = max_distance
var angle: float = 0
var speed: float = 10
var ship_name: String = 'Default Ship'
var status: Status = Status.UNDECIDED:
	set (value):
		if value == Status.APPROVED:
			modulate = Color.CHARTREUSE
			speed = abs(speed)
		if value == Status.REJECTED:
			modulate = Color.CRIMSON
			speed = abs(speed) * -1
		status = value
		if Ui.selected_ship == self:
			Ui.update_ship_details()
	get:
		return status
var type: Type:
	set (value):
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
	if distance > max_distance:
		queue_free()
	else:
		distance -= delta * speed
		position = Vector2(distance, 0).rotated(angle)

func visit_starport() -> void:
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
