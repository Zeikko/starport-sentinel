extends Node

func generate_cargo_info(ship: Ship) -> Dictionary:
	var cargo_info: Dictionary = {}
	var cargo_items: Array = [
		"Clothing", "Medical Supplies", "Jewels", "Liquor", "Houseware", "Livestock",
		"Metals", "Metawheat", "Artwork", "Machinery", "Tools", "Building Material",
		"Junk", "Slaves", "Small Arms", "Food Products", "Grav Tanks", "Ammunition", "Batteries"
	]
	var cargo_hold_number: int = int(ship.type) + 1
	for cargo_hold_index in range(cargo_hold_number):
		var cargo_hold: Dictionary = {}
		var num_items: int = randi_range(1, 3)
		for item_number in range(num_items):
			var item: String = cargo_items.pick_random()
			var quantity: int = randi_range(1, 101)
			cargo_hold[item] = quantity
		cargo_info["Cargo Hold " + str(cargo_hold_index + 1)] = cargo_hold
	return cargo_info
