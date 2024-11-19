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

static var textures: Dictionary = {
	Type.CLOTHING: "res://ship/cargo/icons/clothing.png",
	Type.MEDICALS:  "res://ship/cargo/icons/medicals.png",
	Type.JEWELS: "res://ship/cargo/icons/jewels.png",
	Type.LIQUOR: "res://ship/cargo/icons/liquor.png",
	Type.HOUSEWARE: "res://ship/cargo/icons/houseware.png",
	Type.LIVESTOCK: "res://ship/cargo/icons/livestock.png",
	Type.METALS: "res://ship/cargo/icons/metals.png",
	Type.METAWHEAT: "res://ship/cargo/icons/metawheat.png",
	Type.ARTWORK: "res://ship/cargo/icons/artwork.png",
	Type.MACHINERY: "res://ship/cargo/icons/machinery.png",
	Type.TOOLS: "res://ship/cargo/icons/tools.png",
	Type.BUILDING_MATERIAL: "res://ship/cargo/icons/building_material.png",
	Type.JUNK: "res://ship/cargo/icons/junk.png",
	Type.SLAVES: "res://ship/cargo/icons/slaves.png",
	Type.SMALL_ARMS: "res://ship/cargo/icons/small_arms.png",
	Type.FOOD_PRODUCTS:  "res://ship/cargo/icons/food_products.png",
	Type.GRAV_TANKS: "res://ship/cargo/icons/grav_tanks.png",
	Type.AMMUNITION: "res://ship/cargo/icons/ammunition.png",
	Type.BATTERIES: "res://ship/cargo/icons/batteries.png"
}

var type: Type
var quantity: int


func _init(arg_type: Type, arg_quantity: int) -> void:
	type = arg_type
	quantity = arg_quantity

func get_nodes() -> Node:
	var icon: String = CargoItem.get_icon(type)
	var label: RichTextLabel = RichTextLabel.new()
	label.bbcode_enabled = true
	label.fit_content = true
	label.set_text(icon + ' ' + str(quantity) + ' tons')
	return label

static func get_icon(arg_type: Type) -> String:
	return '[img={width%32}x{height%32}]' + textures.get(arg_type) + '[/img]'
