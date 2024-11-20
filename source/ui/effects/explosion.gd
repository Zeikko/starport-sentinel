extends Node2D

@onready var sound: AudioStreamPlayer2D = $Sound

func play(intensity: float) -> void:
	sound.volume_db = intensity * 3
	sound.play()
