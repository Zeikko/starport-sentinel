extends Control

var selected_ship: Ship:
	set(value):
		selected_ship = value
		update_ship_information()
		update_ship_visual()
		update_cargo_manifest()
		ship_visual_container.show()
		scan_container.hide()
	get:
		return selected_ship
@onready var radar: Radar = %Radar
@onready var ship_name: Label = %ShipName
@onready var status: Label = %Status
@onready var faction: Label = %Faction
@onready var ship_type: Label = %ShipType
@onready var security_rules: VBoxContainer = %SecurityRules
@onready var hit_bar: TextureProgressBar = %HitBar
@onready var hit_points: Label = %HitPoints
@onready var credits: Label = %Credits
@onready var progress_bar: ProgressBar = %ProgressBar
@onready var scan_status: Label = %ScanStatus
@onready var cargo_holds_container: VBoxContainer = %CargoHoldsContainer
@onready var ship_visual_container: Container = %ShipVisualContainer
@onready var scan_container: Container = %ScanContainer
@onready var cargo_manifest: VBoxContainer = %CargoManifest
@onready var weapon: Label = %Weapon
@onready var ship_information_container: VBoxContainer = %ShipInformationContainer
@onready var cargo_manifest_container: VBoxContainer = %CargoManifestContainer


func _process(_delta: float) -> void:
	update_scan()

func update_ship_information() -> void:
	if selected_ship == null:
		ship_information_container.hide()
	else:
		ship_information_container.show()
		ship_name.set_text(selected_ship.ship_name)
		status.set_text(Ship.Status.find_key(selected_ship.status).capitalize())
		faction.set_text(Ship.Faction.find_key(selected_ship.information.faction).capitalize())
		ship_type.set_text(Ship.Type.find_key(selected_ship.information.ship_type).capitalize())
		weapon.set_text(Ship.Weapon.find_key(selected_ship.information.weapon).capitalize())


func update_cargo_manifest() -> void:
	if selected_ship == null:
		cargo_manifest_container.hide()
	else:
		cargo_manifest_container.show()
		for child: Node in cargo_manifest.get_children():
			cargo_manifest.remove_child(child)
		var total: int = 0
		for cargo_item: CargoItem in selected_ship.information.cargo_items:
			total += cargo_item.quantity
			cargo_manifest.add_child(cargo_item.get_nodes())
		var total_label: Label = Label.new()
		total_label.set_text('Total: ' + str(total) + ' tons')
		cargo_manifest.add_child(total_label)

func update_security_briefing() -> void:
	for child: Node in security_rules.get_children():
		security_rules.remove_child(child)
	for security_rule: SecurityRule in Shift.security_rules:
		#for i in 50: #debugging scroll
			security_rules.add_child(security_rule.get_nodes())


func update_starport() -> void:
	hit_bar.set_value(Game.hit_points)
	credits.set_text('Credits: ' + str(Game.credits))


func update_scan() -> void:
	if selected_ship != null:
		if selected_ship.progress_bar.value == 100:
			scan_status.hide()
			progress_bar.hide()
			cargo_holds_container.show()
			update_cargo_holds()
		elif selected_ship.progress_bar.value > 0:
			scan_status.text = "Scanning..."
			scan_status.show()
			progress_bar.show()
			cargo_holds_container.hide()
			update_cargo_holds()
		progress_bar.value = selected_ship.progress_bar.value


func update_cargo_holds() -> void:
	for child: Node in cargo_holds_container.get_children():
		cargo_holds_container.remove_child(child)
	for cargo_hold: CargoHold in selected_ship.cargo_holds:
		var cargo_hold_container: VBoxContainer = VBoxContainer.new()
		cargo_holds_container.add_child(cargo_hold_container)
		cargo_hold_container.add_child(cargo_hold.get_label())
		for cargo_item: CargoItem in cargo_hold.cargo_items:
			cargo_hold_container.add_child(cargo_item.get_nodes())


func update_ship_visual() -> void:
	for child: Node in ship_visual_container.get_children():
		ship_visual_container.remove_child(child)
	if selected_ship:
		ship_visual_container.add_child(selected_ship.visual)


func _on_approve_button_pressed() -> void:
	if selected_ship:
		selected_ship.status = Ship.Status.APPROVED


func _on_reject_button_pressed() -> void:
	if selected_ship:
		selected_ship.status = Ship.Status.REJECTED


func _on_scan_button_pressed() -> void:
	ship_visual_container.hide()
	scan_container.show()
	if selected_ship:
		selected_ship.start_scanning()


func _on_view_button_pressed() -> void:
	ship_visual_container.show()
	scan_container.hide()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("scan"):
		_on_scan_button_pressed()
	if event.is_action_pressed("view"):
		_on_view_button_pressed()
