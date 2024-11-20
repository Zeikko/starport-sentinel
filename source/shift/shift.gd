extends Node

var shift_number: int = 1
var ships_per_shift: int = 10
var ship_counter: int = 0:
	set(value):
		ship_counter = value
	get:
		return ship_counter
var ship_scene: PackedScene = preload('res://ship/ship.tscn')
var time_tracker: TimeTracker = preload('res://shift/time_tracker.gd').new()
var security_rules: Array[SecurityRule] = []
var possible_angles: Array[float] = []
var income: int = 0
var damage: int = 0
var upkeep: int = 50
var paid_upkeep: int = 0
var upkeep_damage: int = 0
var visit_messages: Array[String] = []
@onready var shift_report: Panel = %ShiftReport
@onready var shift_title: Label = %ShiftTitle
@onready var income_label: Label = %IncomeLabel
@onready var damage_label: Label = %DamageLabel
@onready var upkeep_label: Label = %UpkeepLabel
@onready var shift_duration_label: Label = %ShiftDuration
@onready var total_duration_label: Label = %TotalDuration
@onready var upkeep_damage_label: Label = %UpkeepDamageLabel
@onready var new_security_rule_container: VBoxContainer = %NewSecurityRule
@onready var visit_messages_container: VBoxContainer = %VisitMessages
@onready var shift_report_tab: MarginContainer = %ShiftReportTab
@onready var upgrades_tab: MarginContainer = %UpgradesTab

func _ready() -> void:
	create_possible_angles()
	create_ship()
	security_rules.push_back(SecurityRule.create_security_rule())
	Ui.update_security_briefing()
	shift_report.hide()
	time_tracker.start_shift()

func _process(delta: float) -> void:
	time_tracker.update_timetracker(delta)

func create_possible_angles() -> void:
	var number_of_angles: int = 16
	var angle_diff: float = 2 * PI / number_of_angles
	for angle_number: int in range(1, number_of_angles):
		possible_angles.push_back(float(angle_number) * angle_diff)

func create_ship() -> bool:
	if ship_counter < ships_per_shift:
		var ship: Ship = ship_scene.instantiate()
		ship.angle = possible_angles.pick_random()
		possible_angles = possible_angles.filter(func(angle: float) -> float: return ship.angle != angle)
		Ui.radar.ships.add_child(ship)
		ship_counter += 1
		return true
	return false

func create_all_ships() -> void:
	while create_ship(): pass

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
			ship.remove()
	pay_upkeep()
	if Game.hit_points > 0:
		time_tracker.end_shift()
		show_shift_report()
		Game.shift_ended()

func pay_upkeep() -> void:
	paid_upkeep = clamp(Game.credits, 0, upkeep)
	upkeep_damage = upkeep - paid_upkeep
	Game.hit_points -= upkeep_damage
	Game.credits -= paid_upkeep


func show_shift_report() -> void:
	var new_security_rule: SecurityRule = SecurityRule.create_security_rule()
	security_rules.push_back(new_security_rule)
	Ui.update_security_briefing()
	for child: Node in visit_messages_container.get_children():
		visit_messages_container.remove_child(child)
	for visit_message: String in visit_messages:
		var label: RichTextLabel = RichTextLabel.new()
		label.bbcode_enabled = true
		label.fit_content = true
		label.set_text(visit_message)
		visit_messages_container.add_child(label)
	for child: Node in new_security_rule_container.get_children():
		new_security_rule_container.remove_child(child)
	new_security_rule_container.add_child(new_security_rule.get_nodes())
	shift_title.set_text('Shift ' + str(shift_number) + ' complete!')
	income_label.set_text('You earned ' + str(income) + ' credits')
	time_tracker.show_label(shift_duration_label, total_duration_label)
	if (upkeep_damage > 0):
		upkeep_label.set_text('You paid ' + str(paid_upkeep) +
		' of the upkeep of ' + str(upkeep) + ' credits')
		upkeep_damage_label.set_text('You took ' + str(upkeep_damage) + ' damage due to unpaid upkeep.')
		upkeep_damage_label.show()
	else:
		upkeep_label.set_text('You paid the upkeep of ' + str(paid_upkeep) + ' credits')
		upkeep_damage_label.hide()
	damage_label.set_text('You sustained ' + str(damage) + ' damage')
	shift_report.show()
	shift_report_tab.show()
	upgrades_tab.hide()


func _on_start_shift_button_pressed() -> void:
	create_possible_angles()
	visit_messages = []
	ship_counter = 0
	income = 0
	damage = 0
	shift_number += 1
	shift_report.hide()
	time_tracker.start_shift()


func _on_upgrades_button_pressed() -> void:
	upgrades_tab.show()
	shift_report_tab.hide()

func _on_back_button_pressed() -> void:
	shift_report_tab.show()
	upgrades_tab.hide()
