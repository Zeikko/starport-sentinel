extends Control

var faction: Ship.Faction:
	set(value):
		faction = value
		$Sprite.frame = value
