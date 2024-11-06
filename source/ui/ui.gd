extends Node2D

var selected_ship: Ship:
	set(value):
		selected_ship = value
		update_ship_details()
	get:
		return selected_ship
@onready var radar: Node2D = %Radar
@onready var ship_name: Label = %ShipName
@onready var status: Label = %Status
@onready var faction_and_class: Label = %FactionAndClass
@onready var security_rules: VBoxContainer = %SecurityRules
@onready var hit_points: Label = %HitPoints

func update_ship_details() -> void:
	ship_name.set_text(selected_ship.ship_name)
	status.set_text(Ship.Status.find_key(selected_ship.status).capitalize())
	faction_and_class.set_text(
		Ship.Faction.find_key(selected_ship.faction).capitalize() + ' ' +
		Ship.Type.find_key(selected_ship.type).capitalize()
	)


func update_security_briefing() -> void:
	for child in security_rules.get_children():
		security_rules.remove_child(child)
		child.free()
	for security_rule in Game.security_rules:
		var label = Label.new()
		var text = ''
		var faction = security_rule.get('faction')
		var type = security_rule.get('type')
		if faction != null:
			text += Ship.Faction.find_key(faction).capitalize() + ' '
		if type != null:
			text += Ship.Type.find_key(type).capitalize() + 's '
		text += 'are not allowed'
		label.set_text(text)
		security_rules.add_child(label)


func update_starport() -> void:
	hit_points.set_text('Hit Points: ' + str(Game.hit_points) + ' / 100')


func _on_approve_button_pressed() -> void:
	selected_ship.status = Ship.Status.APPROVED


func _on_reject_button_pressed() -> void:
	selected_ship.status = Ship.Status.REJECTED
