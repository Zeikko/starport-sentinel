extends Node2D

@onready var namegen = NameGenerator.new()

func _ready() -> void:
	print("Hello, World!")
	for i: int in 10:
		print(namegen.name_chooser(namegen.Lang.ASDFG)) #ASDFG AUREG BABAB CNZHO FISUO GEDEU TASWA UKENG
