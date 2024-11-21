extends Node2D


func _ready() -> void:
	print("Hello, World!")

func _on_play_game_button_pressed() -> void:
	Global.load_game()

func _on_tutorial_button_pressed() -> void:
	pass # Replace with function body.

func _on_quit_button_pressed() -> void:
	get_tree().quit()
