extends Node

var ship_scene: PackedScene = preload('res://source/ship/ship.tscn')
var security_rules: Array[Dictionary] = []

func _ready() -> void:
	create_ship()
	security_rules.push_back(create_security_rule())
	Ui.update_security_briefing()

func create_ship() -> void:
	var ship: Ship = ship_scene.instantiate()
	ship.angle = randf_range(0, 2) * PI
	Ui.radar.add_child(ship)


func _on_timer_timeout() -> void:
	create_ship()

func create_security_rule() -> Dictionary:
	var type = Ship.Type.values().pick_random()
	var faction = Ship.Faction.values().pick_random()
	var rule_variation = randi_range(0, 1)
	var security_rule = {}
	if rule_variation == 0:
		security_rule.type = type
	if rule_variation == 1:
		security_rule.faction = faction
	return security_rule
