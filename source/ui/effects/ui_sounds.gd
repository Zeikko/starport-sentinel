#https://forum.godotengine.org/t/best-proper-way-to-do-ui-sounds-hover-click/39081/2
class_name UIFX extends Node2D 

var playback: AudioStreamPlaybackPolyphonic

func _enter_tree() -> void:
	# Create an audio player
	var player = AudioStreamPlayer.new()
	add_child(player)
	# Create a polyphonic stream so we can play sounds directly from it
	var stream = AudioStreamPolyphonic.new()
	stream.polyphony = 32
	player.stream = stream
	player.play()
	# Get the polyphonic playback stream to play sounds
	playback = player.get_stream_playback()
	get_tree().node_added.connect(_on_node_added)

func _on_node_added(node:Node) -> void:
	if node is Button:
		# If the added node is a button we connect to its mouse_entered and pressed signals
		# and play a sound
		node.mouse_entered.connect(_play_hover)
		node.pressed.connect(_play_pressed)

func _play_hover() -> void:
	playback.play_stream(
		preload("res://ui/effects/hover.wav"),
		0,
		-6,
		randf_range(0.9, 1.1),
		0,
		"Effects"
	)

func _play_pressed() -> void:
	playback.play_stream(
		preload("res://ui/effects/click.wav"),
		0,
		-6,
		randf_range(0.9, 1.1),
		0,
		"Effects"
	)
