class_name CargoItem extends Object

enum Type {
	CLOTHING,
	MEDICALS,
	JEWELS,
	LIQUOR,
	HOUSEWARE,
	LIVESTOCK,
	METALS,
	METAWHEAT,
	ARTWORK,
	MACHINERY,
	TOOLS,
	BUILDING_MATERIAL,
	JUNK,
	SLAVES,
	SMALL_ARMS,
	FOOD_PRODUCTS,
	GRAV_TANKS,
	AMMUNITION,
	BATTERIES
	}
var type: Type
var quantity: int

func _init(arg_type: Type, arg_quantity: int) -> void:
	type = arg_type
	quantity = arg_quantity

func get_label() -> Label:
	var label: Label = Label.new()
	label.set_text(CargoItem.Type.find_key(type).capitalize() + ': ' + str(quantity) + ' tons')
	return label
