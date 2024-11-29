extends MarginContainer

var type: Ship.Type


var hulls: Array[Resource] = [
	preload("res://ship/visual/parts/base_0.png"),
	preload("res://ship/visual/parts/base_1.png"),
	preload("res://ship/visual/parts/base_2.png")
]

func _ready() -> void:
	%Hull.texture = hulls[type]
	%Label.set_text(Ship.Type.find_key(type).capitalize())
