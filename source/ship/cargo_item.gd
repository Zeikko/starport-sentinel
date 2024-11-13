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
	
static var clothing_texture: Resource = load("res://ship/cargo_icons/clothing.png")
static var medicals_texture: Resource = load("res://ship/cargo_icons/medicals.png")
static var textures: Dictionary = {
	Type.CLOTHING: clothing_texture,
	Type.MEDICALS: medicals_texture
}

var type: Type
var quantity: int


func _init(arg_type: Type, arg_quantity: int) -> void:
	type = arg_type
	quantity = arg_quantity

func get_nodes() -> Node:
	var name: Node = CargoItem.get_icon_or_name(type)
	var container: HBoxContainer = HBoxContainer.new()
	container.add_child(name)
	var label: Label = Label.new()
	label.set_text(str(quantity) + ' tons')
	container.add_child(label)
	return container

static func get_icon_or_name(arg_type: Type) -> Node:
	var texture: Resource = textures.get(arg_type)
	if texture:
		var texture_rext: TextureRect = TextureRect.new()
		texture_rext.texture = texture
		texture_rext.position = Vector2(8, 8)
		texture_rext.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
		return texture_rext
	else:
		var label: Label = Label.new()
		label.set_text(CargoItem.Type.find_key(arg_type).capitalize())
		return label
