extends Node

func generate_cargo_info(ship: Ship) -> Dictionary:
	var cargo_info: Dictionary = {}
	var cargo_items: Array = [
		"Clothing", "Medical Supplies", "Jewels", "Liquor", "Houseware", "Livestock",
		"Metals", "Metawheat", "Artwork", "Machinery", "Tools", "Building Material",
		"Junk", "Slaves", "Small Arms", "Food Products", "Grav Tanks", "Ammunition", "Batteries"
	]
	var cargo_holds: int = int(ship.type) + 1
	for i in range(cargo_holds):
		var cargo_hold: Dictionary = {}
		var num_items: int = randi() % 5 + 1
		for j in range(num_items):
			var item: String = cargo_items[randi() % cargo_items.size()]
			var quantity: int = randi() % 100 + 1
			cargo_hold[item] = quantity
		cargo_info["Cargo Hold " + str(i + 1)] = cargo_hold
	return cargo_info
