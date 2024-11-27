class_name HelpMenu extends Control

const FACTION_ROW_SCENE: PackedScene = preload("./faction_row.tscn")
const SHIP_ROW_SCENE: PackedScene = preload("./ship_row.tscn")
const WEAPON_ROW_SCENE: PackedScene = preload("./weapon_row.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for faction in Ship.Faction.values():
		var faction_row = FACTION_ROW_SCENE.instantiate()
		faction_row.faction = faction
		%Factions.add_child(faction_row)
	for ship_type in Ship.Type.values():
		var ship_row = SHIP_ROW_SCENE.instantiate()
		ship_row.type = ship_type
		%Ships.add_child(ship_row)
	for weapon in Ship.Weapon.values():
		if weapon > 0:
			var WEAPON_ROW_SCENE = WEAPON_ROW_SCENE.instantiate()
			WEAPON_ROW_SCENE.weapon = weapon
			%Weapons.add_child(WEAPON_ROW_SCENE)


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
