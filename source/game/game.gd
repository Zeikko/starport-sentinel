extends Node

signal credits_updated

var bought_upgrades: Array[String] = []
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
	if bought_upgrades.has("armor"):
		armor = 1

func get_ships() -> Array[Ship]:
	var ships: Array[Ship] = []
	for ship: Ship in Ui.radar.ships.get_children():
		if ship is Ship:
			ships.push_back(ship)
	return ships

func upgrade_bought(id: String) -> void:
	if !is_upgrade_bought(id):
		bought_upgrades.append(id)
		print(id)
		match id:
			"armor":
				armor = 1
			"faster_scanner":
				scanning_speed = 100.0
			"image_recognition":
				pass # Unsure on implementation for this example

func is_upgrade_bought(id: String) -> bool:
	return bought_upgrades.has(id)
