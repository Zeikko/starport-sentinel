extends Node2D

var selected_ship: Ship:
	set (value):
		selected_ship = value
		update_ship_details()
	get:
		return selected_ship
@onready var radar: Node2D = %Radar
@onready var ship_name: Label = %ShipName
@onready var status: Label = %Status
@onready var faction_and_class: Label = %FactionAndClass

func update_ship_details() -> void:
	ship_name.set_text(selected_ship.ship_name)
	status.set_text(Ship.Status.find_key(selected_ship.status).capitalize())
	faction_and_class.set_text(
		Ship.Faction.find_key(selected_ship.faction).capitalize()
		+ ' ' + 
		Ship.Type.find_key(selected_ship.type).capitalize()
	)


func _on_approve_button_pressed() -> void:
	selected_ship.status = Ship.Status.APPROVED


func _on_reject_button_pressed() -> void:
	selected_ship.status = Ship.Status.REJECTED
