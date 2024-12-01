class_name Game extends Node

signal credits_updated


const SHIP_TURBO_SPEED: float = 5
const UPGRADES_PATH: String = "res://shift/upgrades/"

var upgrades: Dictionary = {
	Upgrade.Id.SCANNER_SPEED: preload(UPGRADES_PATH + "scanner_speed_up.tres"),
	Upgrade.Id.ARMOR: preload(UPGRADES_PATH + "armor_up.tres"),
	Upgrade.Id.REPAIR_BOTS: preload(UPGRADES_PATH + "repair_bots.tres"),
	Upgrade.Id.SHIELD_GENERATOR: preload(UPGRADES_PATH + "shield_generator.tres")
}
var shield: int = 0
var hit_points: int = 100:
	set(value):
		if value <= 0 && hit_points > 0:
			get_tree().paused = true
			defeat_sound.play()
			camera.shake(10)
			%DefeatEffect1.start()
			Global.ui.top_bar.show_message('Status Critical!', 3)
		hit_points = value
		Global.ui.update_starport()
	get:
		return hit_points
var base_scanning_speed: float = 25.0
var scanning_speed: float = base_scanning_speed
var credits: int = 0:
	set(value):
		credits = value
		Global.ui.update_starport()
		credits_updated.emit()
	get:
		return credits
var factions: Array

@onready var defeat_menu: Panel = %DefeatMenu
@onready var defeat_sound: AudioStreamPlayer2D = %DefeatSound
@onready var camera: Camera2D = %Camera

func _init() -> void:
	Global.game = self
	var all_factions = Ship.Faction.values()
	all_factions.shuffle()
	factions = all_factions.slice(0, 5)

func _ready() -> void:
	Global.ui.update_starport()
	$Cheatcodes.cheatcode_entered.connect(_on_cheatcode_entered)


func _on_cheatcode_entered(code: Cheatcode) -> void:
	match code.id:
		Cheatcode.Id.SPAWN_SHIPS:
			Global.shift.create_all_ships()
		Cheatcode.Id.FAST_SHIPS:
			for ship: Ship in get_ships():
				ship.speed = SHIP_TURBO_SPEED
		Cheatcode.Id.APPROVE_SHIPS:
			for ship: Ship in get_ships():
				ship.status = Ship.Status.APPROVED

func shift_ended() -> void:
	if upgrades[Upgrade.Id.SHIELD_GENERATOR].bought:
		shield = 1

func get_ships() -> Array[Ship]:
	var ships: Array[Ship] = []
	for ship: Ship in Global.ui.radar.ships.get_children():
		if ship is Ship:
			ships.push_back(ship)
	return ships

func upgrade_bought(id: Upgrade.Id) -> void:
	if !upgrades[id].bought:
		upgrades[id].bought = true
		match id:
			Upgrade.Id.SHIELD_GENERATOR:
				shield = 1
			Upgrade.Id.SCANNER_SPEED:
				scanning_speed = base_scanning_speed * 2


func _on_main_menu_button_pressed() -> void:
	Global.load_main_menu()


func _on_defeat_effect_1_timeout() -> void:
	defeat_menu.show()
	%Music.stop()
	%Ambience.stop()
	%DefeatBackground.modulate = Color.html('#ee8695')
	%DefeatBackground.show()
	%DefeatEffect2.start()


func _on_defeat_effect_2_timeout() -> void:
	%DefeatBackground.modulate = Color.html('#333f58')
