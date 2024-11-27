extends MarginContainer

const faction_icon_scene: PackedScene = preload("res://factions/faction_icon.tscn")

var faction: Ship.Faction


func _ready() -> void:
	var faction_icon = faction_icon_scene.instantiate()
	faction_icon.faction = faction
	%Label.set_text(Ship.Faction.find_key(faction).capitalize())
	%Icon.add_child(faction_icon)
	%Icon.scale = Vector2(3, 3)
