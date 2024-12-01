extends Node2D

@onready var sound: AudioStreamPlayer2D = $Sound

func play(intensity: float, game: bool = true) -> void:
	sound.volume_db = intensity * 3
	sound.play()
	%Particles.process_material.set_emission_shape_offset(Vector3(randi_range(320,1600),96,0))
	%Particles.amount = pow(intensity, 2) * 100
	%Particles.emitting = true
	if game: Global.game.camera.shake(intensity)
