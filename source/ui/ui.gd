extends Node2D

var selected_ship: Ship:
	set(value):
		selected_ship = value
		if selected_ship:
			update_ship_information()
			ship_visual.update()
	get:
		return selected_ship
@onready var radar: Node2D = %Radar
@onready var ship_name: Label = %ShipName
@onready var status: Label = %Status
@onready var faction_and_class: Label = %FactionAndClass
@onready var security_rules: VBoxContainer = %SecurityRules
@onready var hit_points: Label = %HitPoints
@onready var scan: VBoxContainer = $Scan
@onready var progress_bar: ProgressBar = %ProgressBar
@onready var scan_button: Button = %ScanButton
@onready var cargo_details: Label = %CargoDetails
@onready var ship_information: Panel = %ShipInformation
@onready var ship_visual: Control = %ShipVisual

func _process(_delta: float) -> void:
	update_scan()

func update_ship_information() -> void:
	if selected_ship == null:
		return
	ship_name.set_text(selected_ship.ship_name)
	status.set_text(Ship.Status.find_key(selected_ship.status).capitalize())
	faction_and_class.set_text(
		Ship.Faction.find_key(selected_ship.information.faction).capitalize() + ' ' +
		Ship.Type.find_key(selected_ship.type).capitalize()
	)


func update_security_briefing() -> void:
	for child: Node in security_rules.get_children():
		security_rules.remove_child(child)
		child.free()
	for security_rule: SecurityRule in Shift.security_rules:
		var label = Label.new()
		label.set_text(security_rule.to_text())
		security_rules.add_child(label)


func update_starport() -> void:
	hit_points.set_text('Hit Points: ' + str(Game.hit_points) + ' / 100')


func update_scan() -> void:
	if selected_ship != null:
		if selected_ship.progress_bar.value == 100:
			scan_button.text = "Scan Complete"
			scan_button.disabled = true
		elif selected_ship.progress_bar.value > 0:
			scan_button.text = "Scanning..."
			scan_button.disabled = true
		else:
			scan_button.text = "Scan"
			scan_button.disabled = false

		progress_bar.value = selected_ship.progress_bar.value

		var cargo_info = selected_ship.cargo_info
		var num_holds = cargo_info.size()
		var holds_to_display = int(progress_bar.value / 100.0 * num_holds)
		var cargo_details_text: String = ""
		var hold_index = 0
		for cargo_hold in cargo_info.keys():
			if hold_index >= holds_to_display:
				break
			cargo_details_text += cargo_hold + ":\n"

			for item in cargo_info[cargo_hold].keys():
				cargo_details_text += "  " + item + ": " + str(cargo_info[cargo_hold][item]) + "\n"
			hold_index += 1
		cargo_details.text = cargo_details_text.strip_edges()
	else:
		scan_button.text = "Scan"
		scan_button.disabled = true
		cargo_details.text = ""


func _on_approve_button_pressed() -> void:
	selected_ship.status = Ship.Status.APPROVED


func _on_reject_button_pressed() -> void:
	selected_ship.status = Ship.Status.REJECTED


func _on_scan_button_pressed() -> void:
	selected_ship.start_scanning()
