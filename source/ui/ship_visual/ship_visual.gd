class_name ShipVisual extends Control

var faction_map: Dictionary = {
	Ship.Faction.VOID_INC: Vector2i(0, 0),
	Ship.Faction.ARGUS_SYNDICATE: Vector2i(2, 0),
	Ship.Faction.ZUBREZ: Vector2i(3, 0),
	Ship.Faction.NHA: Vector2i(0, 1),
	Ship.Faction.C3: Vector2i(1, 1),
	Ship.Faction.HOUSE_FRUGI: Vector2i(2, 1),
	Ship.Faction.FOLLOWERS_OF_OBUDU: Vector2i(3, 1),
}

@onready var faction_logo: TileMapLayer = %FactionLogo

func update() -> void:
	faction_logo.set_cell(Vector2i(0, 0), 0, faction_map[Ui.selected_ship.faction])
