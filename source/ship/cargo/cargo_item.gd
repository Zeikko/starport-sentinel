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

static var clothing_texture: Resource = load("res://ship/cargo/icons/clothing.png")
static var medicals_texture: Resource = load("res://ship/cargo/icons/medicals.png")
static var jewels_texture: Resource = load("res://ship/cargo/icons/jewels.png")
static var liquor_texture: Resource = load("res://ship/cargo/icons/liquor.png")
static var houseware_texture: Resource = load("res://ship/cargo/icons/houseware.png")
static var livestock_texture: Resource = load("res://ship/cargo/icons/livestock.png")
static var metals_texture: Resource = load("res://ship/cargo/icons/metals.png")
static var metawheat_texture: Resource = load("res://ship/cargo/icons/metawheat.png")
static var artwork_texture: Resource = load("res://ship/cargo/icons/artwork.png")
static var machinery_texture: Resource = load("res://ship/cargo/icons/machinery.png")
static var tools_texture: Resource = load("res://ship/cargo/icons/tools.png")
static var building_texture: Resource = load("res://ship/cargo/icons/building_material.png")
static var junk_texture: Resource = load("res://ship/cargo/icons/junk.png")
static var slaves_texture: Resource = load("res://ship/cargo/icons/slaves.png")
static var small_arms_texture: Resource = load("res://ship/cargo/icons/small_arms.png")
static var food_products_texture: Resource = load("res://ship/cargo/icons/food_products.png")
static var grav_tanks_texture: Resource = load("res://ship/cargo/icons/grav_tanks.png")
static var ammunition_texture: Resource = load("res://ship/cargo/icons/ammunition.png")
static var batteries_texture: Resource = load("res://ship/cargo/icons/batteries.png")
static var textures: Dictionary = {
	Type.CLOTHING: clothing_texture,
	Type.MEDICALS: medicals_texture,
	Type.JEWELS: jewels_texture,
	Type.LIQUOR: liquor_texture,
	Type.HOUSEWARE: houseware_texture,
	Type.LIVESTOCK: livestock_texture,
	Type.METALS: metals_texture,
	Type.METAWHEAT: metawheat_texture,
	Type.ARTWORK: artwork_texture,
	Type.MACHINERY: machinery_texture,
	Type.TOOLS: tools_texture,
	Type.BUILDING_MATERIAL: building_texture,
	Type.JUNK: junk_texture,
	Type.SLAVES: slaves_texture,
	Type.SMALL_ARMS: small_arms_texture,
	Type.FOOD_PRODUCTS: food_products_texture,
	Type.GRAV_TANKS: grav_tanks_texture,
	Type.AMMUNITION: ammunition_texture,
	Type.BATTERIES: batteries_texture
}

var type: Type
var quantity: int


func _init(arg_type: Type, arg_quantity: int) -> void:
	type = arg_type
	quantity = arg_quantity

func get_nodes() -> Node:
	var name: Node = CargoItem.get_icon(type)
	var container: HBoxContainer = HBoxContainer.new()
	container.add_child(name)
	var label: Label = Label.new()
	label.set_text(str(quantity) + ' tons')
	container.add_child(label)
	return container

static func get_icon(arg_type: Type) -> Node:
	var texture: Resource = textures.get(arg_type)
	var texture_rext: TextureRect = TextureRect.new()
	texture_rext.texture = texture
	texture_rext.position = Vector2(8, 8)
	texture_rext.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	return texture_rext
