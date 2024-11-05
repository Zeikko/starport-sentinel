extends Node

var ship_scene: PackedScene = preload('res://source/ship/ship.tscn')

func _ready() -> void:
	create_ship()

func create_ship() -> void:
	var ship: Ship = ship_scene.instantiate()
	ship.angle = randf_range(0, 2) * PI
	ship.ship_name = str(randi())
	Ui.radar.add_child(ship)


func _on_timer_timeout() -> void:
	create_ship()
