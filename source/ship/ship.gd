class_name Ship extends Node2D

enum Status {UNDECIDED, APPROVED, REJECTED}
enum Type {SHUTTLE, FRIGATE, CRUISER}
enum Faction {VOID, ARGUS, ZUBREZ, NHA, C3, FRUGI, OBUDU}
var max_distance: float = 300
var min_distance: float = 40
var scale_multiplier: float = 0.1

var distance: float = max_distance
var angle: float = 0
var speed: float = 5
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
		Ui.update_ship_information()
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
var is_scanning: bool = false
var cargo_info: Dictionary = {}
var is_dangerous: bool
var information: ShipInformation

@onready var progress_bar: ProgressBar = %ProgressBar
@onready var select_indicator: TextureRect = %SelectIndicator

func _ready() -> void:
	ship_name = str(randi())
	type = Type.values().pick_random()
	faction = Faction.values().pick_random()
	cargo_info = CargoHelper.generate_cargo_info(self)
	is_dangerous = get_is_dangerous()
	information = ShipInformation.new(is_dangerous, faction)

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
	if is_scanning:
		progress_bar.value += delta * Game.scanning_speed
	if progress_bar.value >= 100:
		is_scanning = false
		progress_bar.visible = false
	select_indicator.visible = Ui.selected_ship == self

func get_is_dangerous() -> bool:
	for security_rule: SecurityRule in Shift.security_rules:
		if (
			security_rule.faction == faction &&
			security_rule.type == type
		):
			return true
	return false

func visit_starport() -> void:
	if is_dangerous:
		var damage: int = 10 * (type + 1)
		Game.hit_points -= damage
		print('Dealt ' + str(damage) + ' damage')
	queue_free()

func start_scanning() -> void:
	progress_bar.visible = true
	is_scanning = true

func _on_area_2d_input_event(
	_viewport: Node,
	event: InputEvent,
	_shape_idx: int
) -> void:
	if event is InputEventMouseButton \
	and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) \
	and (event as InputEventMouseButton).pressed:
		if Ui.selected_ship == self:
			Ui.selected_ship = null
		else:
			Ui.selected_ship = self

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("approve") && self == Ui.selected_ship:
		status = Status.APPROVED
	if event.is_action_pressed("reject") && self == Ui.selected_ship:
		status = Status.REJECTED
