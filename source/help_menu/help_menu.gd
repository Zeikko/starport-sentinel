class_name HelpMenu extends Control

const faction_row_scene: PackedScene = preload("./faction_row.tscn")
const ship_row_scene: PackedScene = preload("./ship_row.tscn")
const weapon_row_scene: PackedScene = preload("./weapon_row.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for faction in Ship.Faction.values():
		var faction_row = faction_row_scene.instantiate()
		faction_row.faction = faction
		%Factions.add_child(faction_row)
	for ship_type in Ship.Type.values():
		var ship_row = ship_row_scene.instantiate()
		ship_row.type = ship_type
		%Ships.add_child(ship_row)
	for weapon in Ship.Weapon.values():
		if weapon > 0:
			var weapon_row_scene = weapon_row_scene.instantiate()
			weapon_row_scene.weapon = weapon
			%Weapons.add_child(weapon_row_scene)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_close_button_pressed() -> void:
	hide()


func _on_factions_button_pressed() -> void:
	%Factions.show()
	%Weapons.hide()
	%Ships.hide()


func _on_weapons_buttons_pressed() -> void:
	%Factions.hide()
	%Weapons.show()
	%Ships.hide()


func _on_ships_button_pressed() -> void:
	%Factions.hide()
	%Weapons.hide()
	%Ships.show()
