class_name ShipVisual extends Control

const FACTION_ICON_SCENE: PackedScene = preload("res://factions/faction_icon.tscn")

var type: Ship.Type
var faction: Ship.Faction
var weapon: Ship.Weapon
var randomize_parts = true

var hulls: Array[Resource] = [
	preload("res://ship/visual/parts/base_0.png"),
	preload("res://ship/visual/parts/base_1.png"),
	preload("res://ship/visual/parts/base_2.png")
]
var cockpits: Array[Resource] = [
	preload("res://ship/visual/parts/cockpit_1.png"),
	preload("res://ship/visual/parts/cockpit_3.png"),
	preload("res://ship/visual/parts/cockpit_4.png")
]
var thrusters: Array[Resource] = [
	preload("res://ship/visual/parts/thruster_1.png"),
	preload("res://ship/visual/parts/thruster_3.png"),
	preload("res://ship/visual/parts/thruster_4.png")
]
var weapons: Array[Resource] = [
	preload("res://ship/visual/parts/weapon_1.png"),
	preload("res://ship/visual/parts/weapon_3.png"),
	preload("res://ship/visual/parts/weapon_4.png")
]
var wings: Array[Resource] = [
	preload("res://ship/visual/parts/wings_0.png"),
	preload("res://ship/visual/parts/wings_1.png"),
	preload("res://ship/visual/parts/wings_2.png"),
	preload("res://ship/visual/parts/wings_3.png"),
	preload("res://ship/visual/parts/wings_4.png")
]
var faction_logo_positions: Dictionary = {
	Ship.Type.SHUTTLE: [Vector2(61, 71)],
	Ship.Type.FRIGATE: [Vector2(61, 71)],
	Ship.Type.CRUISER: [Vector2(45, 69), Vector2(77, 69)]
}

@onready var wings_sprite: Sprite2D = %Wings
@onready var hull_sprite: Sprite2D = %Hull
@onready var thruster_sprite: Sprite2D = %Thruster
@onready var cockpit_sprite: Sprite2D = %Cockpit
@onready var weapon_sprite: Sprite2D = %Weapon

func _ready() -> void:
	if randomize_parts:
		wings_sprite.texture = wings.pick_random()
		thruster_sprite.texture = thrusters.pick_random()
		cockpit_sprite.texture = cockpits.pick_random()
	hull_sprite.texture = hulls[type]
	if weapon == 0:
		weapon_sprite.visible = false
	else:
		weapon_sprite.visible = true
		weapon_sprite.texture = weapons[weapon - 1]
	for logo_position: Vector2 in faction_logo_positions[type]:
		var faction_icon = FACTION_ICON_SCENE.instantiate()
		faction_icon.faction = faction
		faction_icon.position = logo_position
		faction_icon.scale = Vector2(0.35, 0.35)
		add_child(faction_icon)
