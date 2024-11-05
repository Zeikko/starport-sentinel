class_name Ship extends Node2D

var distance: float = 300
var angle: float = 0
var speed: float = 10

func _process(delta: float) -> void:
	if distance < 40:
		visit_starport()
	else:
		distance -= delta * speed
		position = Vector2(distance, 0).rotated(angle)

func visit_starport() -> void:
	queue_free()
