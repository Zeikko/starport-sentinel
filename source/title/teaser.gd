extends Control

@onready var star_resource = preload("res://ui/star.tscn")

func _ready() -> void:
	for i in 400:
		var star = star_resource.instantiate()
		star.position = Vector2(randi_range(0,1920),randi_range(0,1080))
		star.gen_range = 1080
		add_child(star)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		var intensity = randf_range(0.5,2.0)
		%Explosion.play(intensity,false)
		%Camera2D.shake(intensity)
