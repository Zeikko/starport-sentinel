extends Node2D

@onready var radar: Node2D = %Radar
@onready var ship_name: Label = %ShipName

func update_ship_details(ship: Ship) -> void:
	ship_name.set_text(ship.ship_name)
