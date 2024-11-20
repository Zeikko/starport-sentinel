extends Node

signal cheatcode_entered(Cheatcode)

const CHEATCODE_ICON_SCENE: PackedScene = preload("./cheatcodes/cheatcode_icon.tscn")
const CHEATCODE_ICON_IMAGE_PATH: String = "./cheatcodes/icons/cheatcode_arrow"
const ARROW_UP: Texture2D = preload(CHEATCODE_ICON_IMAGE_PATH + "1.png")
const ARROW_RIGHT: Texture2D = preload(CHEATCODE_ICON_IMAGE_PATH + "2.png")
const ARROW_DOWN: Texture2D = preload( CHEATCODE_ICON_IMAGE_PATH + "3.png")
const ARROW_LEFT: Texture2D = preload(CHEATCODE_ICON_IMAGE_PATH + "4.png")
const CHEATCODE_PATH: String = "res://game/cheatcodes/"
const MAX_CHEATCODE: int = 12
const CHEATCODE_START: float = 3
const CHEATCODE_FADETIME: float = 0.5

var cheatcodes: Array[Cheatcode] = [
	preload(CHEATCODE_PATH + "spawn_ships_cheat.tres"),
	preload(CHEATCODE_PATH + "fast_ships_cheat.tres"),
	preload(CHEATCODE_PATH + "approve_ships_cheat.tres"),
]

var input_buffer: Array[InputEvent]
var input_frozen: bool = false
var fade_tween: Tween

@onready var start_fade_timer: Timer = $StartFade
@onready var cheatcode_hbox: HBoxContainer = %CheatcodeInputHbox
@onready var cheatcode_name_label: Label = %CheatcodeNameLabel
@onready var cheatcode_ui: Control = %CheatcodeUi

func add_icon(texture: Texture2D) -> void:
	var icon = CHEATCODE_ICON_SCENE.instantiate()
	icon.texture = texture
	cheatcode_hbox.add_child(icon)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("spawn_all_ships"):
		cheatcode_entered.emit(cheatcodes[Cheatcode.Id.SPAWN_SHIPS])
		return
	if event.is_action_pressed("faster_ships"):
		cheatcode_entered.emit(cheatcodes[Cheatcode.Id.FAST_SHIPS])
		return
	if event.is_action_pressed("approve_all_ships"):
		cheatcode_entered.emit(cheatcodes[Cheatcode.Id.APPROVE_SHIPS])
		return
	if input_buffer.size() >= MAX_CHEATCODE or input_frozen:
		return
	if event.is_action_pressed("cheatcode_up"):
		input_buffer.push_back(event)
		add_icon(ARROW_UP)
	elif event.is_action_pressed("cheatcode_down"):
		input_buffer.push_back(event)
		add_icon(ARROW_DOWN)
	elif event.is_action_pressed("cheatcode_left"):
		input_buffer.push_back(event)
		add_icon(ARROW_LEFT)
	elif event.is_action_pressed("cheatcode_right"):
		input_buffer.push_back(event)
		add_icon(ARROW_RIGHT)
	if input_buffer.size() > 0:
		cheatcode_ui.modulate = Color(1, 1, 1, 1)
		if !start_fade_timer.is_stopped():
			start_fade_timer.stop()
		if fade_tween and fade_tween.is_valid() and fade_tween.is_running():
			fade_tween.stop()
		start_fade_timer.start()
	for code: Cheatcode in cheatcodes:
		if code.combo.size() == input_buffer.size():
			var combo_matches = true
			var i = 0
			for input in input_buffer:
				if !input.is_action_pressed(code.combo[i].action):
					combo_matches = false
				i += 1
			if combo_matches:
				cheatcode_entered.emit(code)
				cheatcode_name_label.text = code.name
				input_frozen = true

func _on_fade_tween_finish() -> void:
	input_frozen = false
	input_buffer = []
	cheatcode_name_label.text = ""
	for child in cheatcode_hbox.get_children():
		child.free()

func _on_start_fade_timeout() -> void:
	fade_tween = create_tween()
	fade_tween.tween_property(cheatcode_ui, "modulate", Color(1, 1, 1, 0), \
		CHEATCODE_FADETIME).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	fade_tween.tween_callback(_on_fade_tween_finish)
