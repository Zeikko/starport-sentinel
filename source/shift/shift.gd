extends Node

var shift_number: int = 1
var ships_per_shift: int = 10
var ship_counter: int = 0:
	set(value):
		ship_counter = value
	get:
		return ship_counter
var ship_scene: PackedScene = preload('res://source/ship/ship.tscn')
var security_rules: Array[SecurityRule] = []
@onready var shift_menu: Panel = %ShiftMenu
@onready var shift_title: Label = %ShiftTitle
@onready var new_security_rule_label: Label = %NewSecurityRule

func _ready() -> void:
	create_ship()
	security_rules.push_back(SecurityRule.create_security_rule(security_rules))
	Ui.update_security_briefing()


func create_ship() -> void:
	if ship_counter < ships_per_shift:
		var ship: Ship = ship_scene.instantiate()
		ship.angle = randf_range(0, 2) * PI
		Ui.radar.ships.add_child(ship)
		ship_counter += 1


func _on_timer_timeout() -> void:
	create_ship()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("new_ship"):
		create_ship()


func is_shift_over(altered_ship: Ship) -> void:
	var is_undecided_ships: bool = false
	var ships: Array[Ship] = Game.get_ships()
	for ship: Ship in ships:
		if ship.status == Ship.Status.UNDECIDED && ship != altered_ship:
			is_undecided_ships = true
	if !is_undecided_ships && ship_counter == ships_per_shift:
		end_shift(ships)


func end_shift(ships: Array[Ship]) -> void:
	for ship: Ship in ships:
		if ship.status == Ship.Status.APPROVED:
			ship.visit_starport()
		else:
			ship.queue_free()
	if Game.hit_points > 0:
		show_shift_menu()


func show_shift_menu() -> void:
	var new_security_rule: SecurityRule = SecurityRule.create_security_rule(security_rules)
	security_rules.push_back(new_security_rule)
	Ui.update_security_briefing()
	new_security_rule_label.set_text(new_security_rule.to_text())
	shift_title.set_text('Shift ' + str(shift_number) + ' complete!')
	shift_menu.show()


func _on_start_shift_button_pressed() -> void:
	ship_counter = 0
	shift_number += 1
	shift_menu.hide()
	
	
