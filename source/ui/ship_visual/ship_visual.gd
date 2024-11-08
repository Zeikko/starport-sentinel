extends Control

@onready var faction_logo: TileMapLayer = %FactionLogo

var faction_map: Dictionary = {
	Ship.Faction.VOID: Vector2i(0, 0),
	Ship.Faction.ARGUS: Vector2i(2, 0),
	Ship.Faction.OBUDU: Vector2i(3, 1),
}

func update() -> void:
	faction_logo.set_cell(Vector2i(0, 0), 0, faction_map[Ui.selected_ship.faction])
