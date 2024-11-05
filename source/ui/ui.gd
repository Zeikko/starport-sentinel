extends Node2D

@onready var radar: Node2D = %Radar
@onready var ship_name: Label = %ShipName
@onready var status: Label = %Status

var selected_ship: Ship:
	set (value):
		selected_ship = value
		update_ship_details()
	get:
		return selected_ship

func update_ship_details() -> void:
	ship_name.set_text(selected_ship.ship_name)
	if selected_ship.status == Ship.Status.APPROVED:
		status.set_text('Approved')
	elif selected_ship.status == Ship.Status.REJECTED:
		status.set_text('Rejected')
	else:
		status.set_text('Undecided')

func _on_approve_button_pressed() -> void:
	selected_ship.status = Ship.Status.APPROVED


func _on_reject_button_pressed() -> void:
	selected_ship.status = Ship.Status.REJECTED
