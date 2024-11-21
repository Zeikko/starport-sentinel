extends Node

const GAME_SCENE: PackedScene = preload("res://game/game.tscn")
const MAIN_MENU_SCENE: PackedScene = preload("res://main.tscn")

var ui: Ui
var game: Game
var shift: Shift

func load_game() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_packed(GAME_SCENE)

func load_main_menu() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_packed(MAIN_MENU_SCENE)
