extends MarginContainer

var weapon: Ship.Weapon


var weapons: Array[Resource] = [
	preload("res://ship/visual/parts/weapon_1.png"),
	preload("res://ship/visual/parts/weapon_3.png"),
	preload("res://ship/visual/parts/weapon_4.png")
]

func _ready() -> void:
	%Weapon.texture = weapons[weapon - 1]
	%Label.set_text(Ship.Weapon.find_key(weapon).capitalize())
