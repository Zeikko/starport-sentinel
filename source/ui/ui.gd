extends Node2D

var selected_ship: Ship:
	set(value):
		selected_ship = value
		if selected_ship:
			update_ship_information()
			ship_visual.update()
	get:
		return selected_ship
var holds_to_display: int = 0:
	set(value):
		holds_to_display = value
		update_cargo_holds()
	get:
		return holds_to_display
@onready var radar: Radar = %Radar
@onready var ship_name: Label = %ShipName
@onready var status: Label = %Status
@onready var faction_and_class: Label = %FactionAndClass
@onready var security_rules: VBoxContainer = %SecurityRules
@onready var hit_points: Label = %HitPoints
@onready var credits: Label = %Credits
@onready var scan: VBoxContainer = $Scan
@onready var progress_bar: ProgressBar = %ProgressBar
@onready var scan_button: Button = %ScanButton
@onready var cargo_holds_container: VBoxContainer = %CargoHoldsContainer
@onready var ship_information: Panel = %ShipInformation
@onready var ship_visual: ShipVisual = %ShipVisual
@onready var cargo_manifest: VBoxContainer = %CargoManifest

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
	update_cargo_manifest()


func update_cargo_manifest() -> void:
	for child: Node in cargo_manifest.get_children():
		cargo_manifest.remove_child(child)
	var total: int = 0
	for cargo_item: CargoItem in selected_ship.information.cargo_items:
		total += cargo_item.quantity
		cargo_manifest.add_child(cargo_item.get_label())
	var total_label: Label = Label.new()
	total_label.set_text('Total: ' + str(total) + ' tons')
	cargo_manifest.add_child(total_label)

func update_security_briefing() -> void:
	for child: Node in security_rules.get_children():
		security_rules.remove_child(child)
	for security_rule: SecurityRule in Shift.security_rules:
		var label: Label = Label.new()
		label.custom_minimum_size = Vector2(160,0)
		label.autowrap_mode = TextServer.AUTOWRAP_WORD
		label.set_text(security_rule.to_text())
		security_rules.add_child(label)


func update_starport() -> void:
	hit_points.set_text('Hit Points: ' + str(Game.hit_points) + ' / 100')
	credits.set_text('Credits: ' + str(Game.credits))


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

		var cargo_holds: Array[CargoHold] = selected_ship.cargo_holds
		holds_to_display = int(progress_bar.value / 100.0 * cargo_holds.size())
	else:
		scan_button.text = "Scan"
		scan_button.disabled = true

func update_cargo_holds() -> void:
	for child: Node in cargo_holds_container.get_children():
		cargo_holds_container.remove_child(child)
	var hold_index: int = 0
	for cargo_hold: CargoHold in selected_ship.cargo_holds:
		if hold_index >= holds_to_display:
			break
		var cargo_hold_container: VBoxContainer = VBoxContainer.new()
		cargo_holds_container.add_child(cargo_hold_container)
		cargo_hold_container.add_child(cargo_hold.get_label())
		for cargo_item: CargoItem in cargo_hold.cargo_items:
			cargo_hold_container.add_child(cargo_item.get_label())
		hold_index += 1


func _on_approve_button_pressed() -> void:
	selected_ship.status = Ship.Status.APPROVED


func _on_reject_button_pressed() -> void:
	selected_ship.status = Ship.Status.REJECTED


func _on_scan_button_pressed() -> void:
	selected_ship.start_scanning()
