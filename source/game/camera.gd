extends Camera2D

var shake_intensity: float = 0.0
var shake_fade: float = 5

func shake(intensity: float):
	shake_intensity = 10 * intensity


func _process(delta: float) -> void:
	if shake_intensity > 1:
		shake_intensity = lerpf(shake_intensity, 0, shake_fade * delta)
		offset = Vector2(
			randf_range(-shake_intensity, shake_intensity),
			randf_range(-shake_intensity, shake_intensity)
		)
