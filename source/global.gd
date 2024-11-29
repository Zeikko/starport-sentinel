extends Node

const GAME_SCENE: PackedScene = preload("res://game/game.tscn")
const MAIN_MENU_SCENE: PackedScene = preload("res://main.tscn")
const TUTORIAL_SCENE: PackedScene = preload("res://tutorial/tutorial.tscn")

var ui: Ui
var game: Game
var shift: Shift
var tutorial: Tutorial

func load_game() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_packed(GAME_SCENE)
	
func load_tutorial() -> void:
	tutorial = TUTORIAL_SCENE.instantiate()
	get_tree().paused = false
	get_tree().change_scene_to_packed(GAME_SCENE)
	

func load_main_menu() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_packed(MAIN_MENU_SCENE)
