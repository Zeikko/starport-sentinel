extends Node2D

@onready var sound: AudioStreamPlayer2D = $Sound

func play(intensity: float) -> void:
	sound.volume_db = intensity * 3
	sound.play()
	%Partikles.process_material.set_emission_shape_offset(Vector3(randi_range(320,1600),96,0))
	%Partikles.emitting = true
