class_name ShipVisual extends Control

var faction_map: Dictionary = {
	Ship.Faction.VOID_INC: Vector2i(0, 0),
	Ship.Faction.ARGUS: Vector2i(2, 0),
	Ship.Faction.ZUBREZ: Vector2i(3, 0),
	Ship.Faction.NHA: Vector2i(0, 1),
	Ship.Faction.C3: Vector2i(1, 1),
	Ship.Faction.FRUGI: Vector2i(2, 1),
	Ship.Faction.OBUDU: Vector2i(3, 1),
}
var ship: Ship

var factions_tile_set: Resource = preload("res://ship/visual/factions_tileset.tres")

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
	Ship.Type.SHUTTLE: [Vector2(56, 66)],
	Ship.Type.FRIGATE: [Vector2(56, 66)],
	Ship.Type.CRUISER: [Vector2(40, 64), Vector2(72, 64)]
}

@onready var wings_sprite: Sprite2D = %Wings
@onready var hull_sprite: Sprite2D = %Hull
@onready var thruster_sprite: Sprite2D = %Thruster
@onready var cockpit_sprite: Sprite2D = %Cockpit
@onready var weapon_sprite: Sprite2D = %Weapon

func _ready() -> void:
	wings_sprite.texture = wings.pick_random()
	hull_sprite.texture = hulls[ship.type]
	thruster_sprite.texture = thrusters.pick_random()
	cockpit_sprite.texture = cockpits.pick_random()
	if ship.weapon == 0:
		weapon_sprite.visible = false
	else:
		weapon_sprite.visible = true
		weapon_sprite.texture = weapons[ship.weapon - 1]
	for logo_position: Vector2 in faction_logo_positions[ship.type]:
		var faction_logo_tilemap: TileMapLayer = TileMapLayer.new()
		faction_logo_tilemap.set_tile_set(factions_tile_set)
		faction_logo_tilemap.set_cell(Vector2i(0, 0), 0, faction_map[ship.faction])
		faction_logo_tilemap.position = logo_position
		add_child(faction_logo_tilemap)
