extends Node

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
var scanning_speed: float = 50.0
var credits: int = 0:
	set(value):
		credits = value
		Ui.update_starport()
	get:
		return credits

@onready var defeat_menu: Panel = %DefeatMenu

func _ready() -> void:
	Ui.update_starport()

func get_ships() -> Array[Ship]:
	var ships: Array[Ship] = []
	for ship: Ship in Ui.radar.ships.get_children():
		if ship is Ship:
			ships.push_back(ship)
	return ships
