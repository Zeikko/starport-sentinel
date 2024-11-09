class_name ShipInformation extends Object

var faction: Ship.Faction
var cargo_items: Array[CargoItem]

func _init(arg_ship: Ship) -> void:
	if arg_ship.is_dangerous:
		faction = Ship.Faction.values().pick_random()
	else:
		faction = arg_ship.faction
	var cargo: Dictionary
	for cargo_hold: CargoHold in arg_ship.cargo_holds:
		for cargo_items: CargoItem in cargo_hold.cargo_items:
			if cargo.get(cargo_items.type):
				cargo[cargo_items.type] += cargo_items.quantity
			else:
				cargo[cargo_items.type] = cargo_items.quantity
	for cargo_item_type: CargoItem.Type in cargo.keys():
		cargo_items.push_back(CargoItem.new(cargo_item_type, cargo[cargo_item_type]))
