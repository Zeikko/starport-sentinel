extends Node

var ship_scene = preload('res://source/ship/ship.tscn')

func _ready() -> void:
	create_ship()
	
func create_ship() -> void:
	var ship = ship_scene.instantiate()
	ship.angle = randf_range(0,2) * PI
	Ui.radar.add_child(ship)


func _on_timer_timeout() -> void:
	create_ship()
