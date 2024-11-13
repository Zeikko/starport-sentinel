extends Node

var shift_number: int = 1
var ships_per_shift: int = 10
var dangerous_ship_counter: int = 0
var ship_counter: int = 0:
	set(value):
		ship_counter = value
	get:
		return ship_counter

var ship_scene: PackedScene = preload('res://ship/ship.tscn')
var time_tracker: TimeTracker = TimeTracker.new()
var shift_highlights : ShiftHighlights

var security_rules: Array[SecurityRule] = []
var possible_angles: Array[float] = []
var shifts_highlights: Array[ShiftHighlights] = []
var credits_gaind_history : Array[float] = []

@onready var shift_menu: Panel = %ShiftMenu
@onready var shift_title: Label = %ShiftTitle
@onready var new_security_rule_label: Label = %NewSecurityRule
@onready var shift_duration_label : Label = %ShiftDuration
@onready var total_duration_label : Label = %TotalDuration
@onready var shifts_highlights_container : VBoxContainer = %ShiftsHighlights

func _ready() -> void:
	create_possible_angles()
	create_ship()
	security_rules.push_back(SecurityRule.create_security_rule(security_rules))
	Ui.update_security_briefing()

func _process(delta: float) -> void:
	time_tracker.uptade_timetracker(delta)
	
	

func create_possible_angles() -> void:
	var number_of_angles: int = 16
	var angle_diff: float = 2 * PI / number_of_angles
	for angle_number: int in range(1, number_of_angles):
		possible_angles.push_back(float(angle_number) * angle_diff)

func create_ship() -> void:
	if ship_counter < ships_per_shift:
		var ship: Ship = ship_scene.instantiate()
		ship.angle = possible_angles.pick_random()
		possible_angles = possible_angles.filter(func(angle: float) -> float: return ship.angle != angle)
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
		time_tracker.end_shift()
		credits_gaind_history.push_back(Game.credits)
		update_shifts_highlights_container()
		show_shift_menu()
		


func show_shift_menu() -> void:
	var new_security_rule: SecurityRule = SecurityRule.create_security_rule(security_rules)
	security_rules.push_back(new_security_rule)
	Ui.update_security_briefing()
	new_security_rule_label.set_text(new_security_rule.to_text())
	shift_title.set_text('Shift ' + str(shift_number) + ' complete!')
	time_tracker.show_label(shift_duration_label, total_duration_label)
	shift_menu.show()

func add_shift_highlights() -> void:
	pass

func _on_start_shift_button_pressed() -> void:
	create_possible_angles()
	ship_counter = 0
	shift_number += 1
	shift_menu.hide()



	
func update_shifts_highlights_container() -> void:
	var args_array : Array[float] = [ship_counter, dangerous_ship_counter, Game.credits, time_tracker.shift_duration]
	shifts_highlights.push_back(ShiftHighlights.new(ship_counter, dangerous_ship_counter, Game.credits, time_tracker.shift_duration))

	for child: Node in shifts_highlights_container.get_children():
		shifts_highlights_container.remove_child(child)
	for shift: ShiftHighlights in shifts_highlights:
		var shift_highlights_container : VBoxContainer = VBoxContainer.new()
		shifts_highlights_container.add_child(shift_highlights_container)
		for item in args_array:
			shift_highlights_container.add_child(shift.get_label(int(args_array.find(item))))



func _on_shifts_highlights_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		shifts_highlights_container.show()
	else:
		shifts_highlights_container.hide()
