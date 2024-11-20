extends Node

signal credits_updated

const UPGRADES_PATH: String = "res://shift/upgrades/"

var upgrades: Dictionary  = {
	Upgrade.Id.SCANNER_SPEED: preload(UPGRADES_PATH + "scanner_speed_up.tres"),
	Upgrade.Id.ARMOR: preload(UPGRADES_PATH + "armor_up.tres")
}

var armor: int = 0

var hit_points: int = 100:
	set(value):
		if value <= 0:
			defeat_menu.show()
			print('Defeat!')
			get_tree().paused = true
		hit_points = value
		Ui.update_starport()
	get:
		return hit_points
var base_scanning_speed: float = 50.0
var scanning_speed: float = base_scanning_speed
var credits: int = 0:
	set(value):
		credits = value
		Ui.update_starport()
		credits_updated.emit()
	get:
		return credits

@onready var defeat_menu: Panel = %DefeatMenu

func _ready() -> void:
	Ui.update_starport()

func shift_ended() -> void:
	if upgrades[Upgrade.Id.ARMOR].bought:
		armor = 1

func get_ships() -> Array[Ship]:
	var ships: Array[Ship] = []
	for ship: Ship in Ui.radar.ships.get_children():
		if ship is Ship:
			ships.push_back(ship)
	return ships

func upgrade_bought(id: Upgrade.Id) -> void:
	if !upgrades[id].bought:
		upgrades[id].bought = true
		match id:
			Upgrade.Id.ARMOR:
				armor = 1
			Upgrade.Id.SCANNER_SPEED:
				scanning_speed = 100.0
