class_name Ship extends Node2D

enum Status {UNDECIDED, APPROVED, REJECTED}
enum Type {SHUTTLE, FRIGATE, CRUISER}
enum Faction {
	VOID_INC,
	ARGUS,
	ZUBREZ,
	NHA,
	C3,
	FRUGI,
	OBUDU
}
enum Weapon {
	NONE,
	BEAM,
	MISSILE,
	CANNON
}

var ship_visual_scene: PackedScene = preload('res://ship/visual/ship_visual.tscn')
var radar_blip_scene: PackedScene = preload('res://ship/radar/radar_blip.tscn')

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
			speed = abs(speed)
		if value == Status.REJECTED:
			speed = abs(speed) * -1
		status = value
		radar_blip.update()
		Global.ui.update_ship_information()
		Global.shift.is_shift_over(self)
var type: Type
var faction: Faction
var is_scanning: bool = false:
	set(value):
		if value && !is_scanning:
			progress_bar.show()
			scan_sound.play()
		if !value && is_scanning:
			scan_sound.stop()
			progress_bar.hide()
		is_scanning = value
var damage: int
var information: ShipInformation
var cargo_holds: Array[CargoHold] = []
var visual: ShipVisual
var visit_message: String
var weapon: Weapon

@onready var progress_bar: ProgressBar = %ProgressBar
@onready var select_indicator: TextureRect = %SelectIndicator
@onready var radar_blip: Node2D
@onready var scan_sound: AudioStreamPlayer2D = $ScanSound

func _ready() -> void:
	position = Vector2(distance, 0).rotated(angle)
	ship_name = str(randi())
	type = Type.values().pick_random()
	weapon = Weapon.values().pick_random()
	damage = 10 * (type + 1)
	faction = Faction.values().pick_random()
	for cargo_hold_number: int in range(type + 1):
		cargo_holds.push_back(CargoHold.new(cargo_hold_number + 1, type))
	information = ShipInformation.new(self)
	visual = ship_visual_scene.instantiate()
	visual.ship = self
	radar_blip = radar_blip_scene.instantiate()
	radar_blip.ship = self
	add_child(radar_blip)


func pick_type() -> void:
	var random_value: int = randi_range(1, 6)
	if (random_value == 6): # 1 of 6
		type = Type.CRUISER
	elif (random_value > 3): # 2 of 6
		type = Type.FRIGATE
	else: # 3 of 6
		type = Type.SHUTTLE


func _process(delta: float) -> void:
	if distance < min_distance:
		visit_starport()
		Global.shift.is_shift_over(self)
	if distance > max_distance:
		remove()
		Global.shift.is_shift_over(self)
	elif self != null:
		if status in [Status.APPROVED, Status.REJECTED] or \
		distance > waiting_distance:
			distance -= delta * speed
		else:
			wait_time_elapsed += delta
		position = Vector2(distance, 0).rotated(angle)
	if Global.ui.selected_ship == self:
		if is_scanning:
			progress_bar.value += delta * Global.game.scanning_speed
		if progress_bar.value >= 100:
			is_scanning = false
	select_indicator.visible = Global.ui.selected_ship == self
	if Input.is_action_just_pressed("ui_select"): Global.ui.explosion.play(damage / 10) #DEBUG!

func visit_starport() -> void:
	var visit_message: String
	for security_rule in Global.shift.security_rules:
		visit_message = security_rule.get_visit_message(self)
		if !visit_message.is_empty():
			break
	if visit_message.is_empty():
		var credits: int = 10 * (type + 1)
		credits *= 1 - wait_time_elapsed / max_wait_time
		Global.game.credits += credits
		Global.shift.income += credits
	else:
		Global.ui.explosion.play(damage / 10)
		if Global.game.armor <= 0:
			Global.game.hit_points -= damage
			Global.shift.damage += damage
			Global.shift.visit_messages.push_back(visit_message)
		else:
			Global.shift.visit_messages.push_back(str('Armor protected you from ', damage, ' damage'))
			Global.game.armor -= 1
	remove()

func remove() -> void:
	if Global.ui.selected_ship == self:
		Global.ui.selected_ship = null
	visual.queue_free()
	queue_free()


func _on_area_2d_input_event(
	_viewport: Node,
	event: InputEvent,
	_shape_idx: int
) -> void:
	if event is InputEventMouseButton \
	and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) \
	and (event as InputEventMouseButton).pressed:
		if Global.ui.selected_ship == self:
			Global.ui.selected_ship = null
		else:
			Global.ui.selected_ship = self

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("approve") && self == Global.ui.selected_ship:
		status = Status.APPROVED
	if event.is_action_pressed("reject") && self == Global.ui.selected_ship:
		status = Status.REJECTED
