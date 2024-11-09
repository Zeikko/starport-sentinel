class_name ShipInformation extends Object

var faction: Ship.Faction

func _init(is_dangerous: bool, arg_faction: Ship.Faction) -> void:
	if is_dangerous:
		faction = Ship.Faction.values().pick_random()
	else:
		faction = arg_faction
