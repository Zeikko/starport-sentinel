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

var shuttle_texture = load("res://ship/radar/shuttle.png")
var cruiser_texture = load("res://ship/radar/cruiser.png")
var frigate_texture = load("res://ship/radar/frigate.png")
var ship_visual_scene: PackedScene = preload('res://ship/visual/ship_visual.tscn')

var max_distance: float = 75
var min_distance: float = 10
var waiting_distance: float = 20
var max_wait_time: float = 10

var distance: float = max_distance
var angle: float = 0
var speed: float = 1
var wait_time_elapsed: float = 0:
	set(value):
		wait_time_elapsed = clamp(value, 0, max_wait_time)
		if wait_time_elapsed == max_wait_time:
			status = Status.REJECTED
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
var type: Type
var faction: Faction
var is_scanning: bool = false
var is_dangerous: bool
var damage: int
var information: ShipInformation
var cargo_holds: Array[CargoHold] = []
var visual: ShipVisual
var visit_message: String

@onready var progress_bar: ProgressBar = %ProgressBar
@onready var select_indicator: TextureRect = %SelectIndicator
@onready var radar_blip: Node2D = %RadarBlip

func _ready() -> void:
	position = Vector2(distance, 0).rotated(angle)
	ship_name = str(randi())
	type = Type.values().pick_random()
	damage = 10 * (type + 1)
	faction = Faction.values().pick_random()
	for cargo_hold_number: int in range(type + 1):
		cargo_holds.push_back(CargoHold.new(cargo_hold_number + 1, type))
	information = ShipInformation.new(self)
	set_radar_texture()
	visual = ship_visual_scene.instantiate()
	visual.ship = self

func pick_type() -> void:
	var random_value: int = randi_range(1,6)
	if (random_value == 6): # 1 of 6
		type = Type.CRUISER
	elif (random_value > 3): # 2 of 6
		type = Type.FRIGATE
	else: # 3 of 6
		type = Type.SHUTTLE

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
		if status in [Status.APPROVED, Status.REJECTED] or \
		distance > waiting_distance:
			distance -= delta * speed
		else:
			wait_time_elapsed += delta
		position = Vector2(distance, 0).rotated(angle)
	if is_scanning:
		progress_bar.value += delta * Game.scanning_speed
	if progress_bar.value >= 100:
		is_scanning = false
		progress_bar.visible = false
	select_indicator.visible = Ui.selected_ship == self

func visit_starport() -> void:
	if is_dangerous:
		if Game.armor <= 0:
			Game.hit_points -= damage
			Shift.damage += damage
		else:
			print("Armor protected you from damage")
			Game.armor -= 1
		Shift.visit_messages.push_back(visit_message)
	else:
		var credits: int = 10 * (type + 1)
		credits *= 1 - wait_time_elapsed / max_wait_time
		Game.credits += credits
		Shift.income += credits
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
