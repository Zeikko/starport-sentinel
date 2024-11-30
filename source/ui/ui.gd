class_name Ui extends Control

@export var scanlight: Resource
var selected_ship: Ship:
	set(value):
		if selected_ship:
			selected_ship.is_scanning = false
		selected_ship = value
		update_ship_information()
		update_ship_visual()
		update_cargo_manifest()
		ship_visual_container.show()
		update_scan()
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
@onready var scan_frame: TextureRect = %ScanFrame
@onready var scan_status: Label = %ScanStatus
@onready var scan_button: Button = %ScanButton
@onready var cargo_holds_container: VBoxContainer = %CargoHoldsContainer
@onready var ship_visual_container: Container = %ShipVisualContainer
@onready var scan_container: Container = %ScanContainer
@onready var cargo_manifest: VBoxContainer = %CargoManifest
@onready var weapon: Label = %Weapon
@onready var ship_information_container: VBoxContainer = %ShipInformationContainer
@onready var cargo_manifest_container: VBoxContainer = %CargoManifestContainer
@onready var explosion: Node2D = %Explosion
@onready var trade: Node2D = %Trade
@onready var star_resource = preload("res://ui/star.tscn")
@onready var help_menu: HelpMenu = %HelpMenu
@onready var top_bar: TopBar = %TopBar

func _ready() -> void:
	Global.ui = self
	if Global.tutorial:
		add_child(Global.tutorial)
	for i in 50:
		var star = star_resource.instantiate()
		star.position = Vector2(randi_range(0,1920),randi_range(0,64))
		add_child(star)

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
			child.queue_free()
		var total: int = 0
		for cargo_item: CargoItem in selected_ship.information.cargo_items:
			total += cargo_item.quantity
			cargo_manifest.add_child(cargo_item.get_nodes())
		var total_label: Label = Label.new()
		var max_capacity = 0
		for cargo_hold in selected_ship.cargo_holds:
			max_capacity += cargo_hold.capacity_max
		total_label.set_text(str('Total: ', total, ' / ', max_capacity))
		cargo_manifest.add_child(total_label)

func update_security_briefing() -> void:
	for child: Node in security_rules.get_children():
		security_rules.remove_child(child)
		child.queue_free()
	for security_rule: SecurityRule in Global.shift.security_rules:
		#for i in 50: #debugging scroll
			security_rules.add_child(security_rule.get_nodes())


func update_starport() -> void:
	hit_bar.set_value(Global.game.hit_points)
	credits.set_text('Credits: ' + str(Global.game.credits))


func update_scan() -> void:
	if selected_ship != null:
		if selected_ship.progress_bar.value == 100:
			scan_button.hide()
			scan_frame.hide()
			scan_container.show()
			scan_status.hide()
			progress_bar.hide()
			
			for child in scan_container.get_children():
				if child is Panel:
					scan_container.remove_child(child)
					child.queue_free()
			cargo_holds_container.show()
			update_cargo_holds()
		elif selected_ship.progress_bar.value > 0 && selected_ship.is_scanning:
			scan_button.hide()
			scan_container.show()
			scan_status.text = "Scanning..."
			if !progress_bar.visible:
				for scanning in 10:
					var scan = scanlight.instantiate()
					scan_container.add_child(scan)
			scan_status.show()
			progress_bar.show()
			scan_frame.show()
			cargo_holds_container.hide()
		else:
			scan_button.show()
			scan_frame.show()
			scan_container.hide()
		progress_bar.value = selected_ship.progress_bar.value


func update_cargo_holds() -> void:
	for child: Node in cargo_holds_container.get_children():
		cargo_holds_container.remove_child(child)
		child.queue_free()
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
	scan_container.show()
	if selected_ship:
		update_cargo_holds()
		selected_ship.is_scanning = true


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("scan"):
		_on_scan_button_pressed()


func _on_help_button_pressed() -> void:
	help_menu.show()
	Global.tutorial.complete(Tutorial.Step.OPEN_HELP)
	get_tree().paused = true
