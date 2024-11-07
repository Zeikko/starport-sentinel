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

@onready var defeat_menu: Panel = %DefeatMenu

func _ready() -> void:
	pass

func get_ships() -> Array[Ship]:
	var ships: Array[Ship] = []
	for ship in Ui.radar.ships.get_children():
		if ship is Ship:
			ships.push_back(ship)
	return ships
