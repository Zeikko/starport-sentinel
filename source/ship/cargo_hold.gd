class_name CargoHold extends Object

var max_capacities: Dictionary = {
	Ship.Type.SHUTTLE: 25,
	Ship.Type.FRIGATE: 50,
	Ship.Type.CRUISER: 100
}
var number: int
var cargo_items: Array[CargoItem] = []
var capacity_max: int
var capacity_used: int


func _init(arg_number: int, arg_type: Ship.Type) -> void:
	number = arg_number
	capacity_max = max_capacities[arg_type]
	var minimum_cargo_size: int = round(float(capacity_max) / 3)
	var capacity_left: int = capacity_max - capacity_used
	while capacity_left > minimum_cargo_size:
		var quantity: int = randi_range(minimum_cargo_size, capacity_left)
		cargo_items.push_back(CargoItem.new(CargoItem.Type.values().pick_random(), quantity))
		capacity_used += quantity
		capacity_left = capacity_max - capacity_used


func get_label() -> Label:
	var label: Label = Label.new()
	label.set_text('Cargo Hold ' + str(number) + ':')
	return label
