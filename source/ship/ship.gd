class_name Ship extends Node2D

var distance: float = 300
var angle: float = 0
var speed: float = 10
var ship_name: String = 'Default Ship'

func _process(delta: float) -> void:
	if distance < 40:
		visit_starport()
	else:
		distance -= delta * speed
		position = Vector2(distance, 0).rotated(angle)

func visit_starport() -> void:
	queue_free()


func _on_area_2d_input_event(_viewport: Node, event: InputEventMouseButton, _shape_idx: int) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) && event.pressed:
		Ui.update_ship_details(self)
