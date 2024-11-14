class_name Ship extends Node2D

enum Status {UNDECIDED, APPROVED, REJECTED}
enum Type {SHUTTLE, FRIGATE, CRUISER}
enum Faction {
	VOID_INC,
	ARGUS_SYNDICATE,
	ZUBREZ,
	NHA,
	C3,
	HOUSE_FRUGI,
	FOLLOWERS_OF_OBUDU
}

var shuttle_texture = load("res://ship/shuttle.png")
var cruiser_texture = load("res://ship/cruiser.png")
var frigate_texture = load("res://ship/frigate.png")

var max_distance: float = 75
var min_distance: float = 10

var distance: float = max_distance
var angle: float = 0
var speed: float = 1
var ship_name: String = 'Default Ship'
var status: Status = Status.UNDECIDED:
	set(value):
		if value == Status.APPROVED:
			radar_blip.modulate = Color.html('#333f58')
			speed = abs(speed)
		if value == Status.REJECTED:
			radar_blip.modulate = Color.html('#ee8695')
			speed = abs(speed) * -1
		status = value
		Ui.update_ship_information()
		Shift.is_shift_over(self)
	get:
		return status
var type: Type:
	set(value):
		type = value
	get:
		return type
var faction: Faction
var is_scanning: bool = false
var is_dangerous: bool
var information: ShipInformation
var cargo_holds: Array[CargoHold] = []

@onready var progress_bar: ProgressBar = %ProgressBar
@onready var select_indicator: TextureRect = %SelectIndicator
@onready var radar_blip: Node2D = %RadarBlip

func _ready() -> void:
	position = Vector2(distance, 0).rotated(angle)
	ship_name = str(randi())
	type = Type.values().pick_random()
	faction = Faction.values().pick_random()
	is_dangerous = get_is_dangerous()
	for cargo_hold_number: int in range(type + 1):
		cargo_holds.push_back(CargoHold.new(cargo_hold_number + 1, type))
	information = ShipInformation.new(self)
	set_radar_texture()


func set_radar_texture() -> void:
	if (type == Type.SHUTTLE):
		radar_blip.texture = shuttle_texture
	elif (type == Type.FRIGATE):
		radar_blip.texture = frigate_texture
	elif (type == Type.CRUISER):
		radar_blip.texture = cruiser_texture

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
		Shift.dangerous_ship_counter += 1
	else:
		var credits: int = 10 * (type + 1)
		Game.credits += credits
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
