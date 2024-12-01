extends Node2D

const INPUT_KEYS = ['approve', 'reject', 'scan']

var is_rebinding_key = false
var current_action_to_rebind: String = ""
var current_button_to_update: Button

@onready var main: Control = $CanvasLayer/Main
@onready var settings: Control = %Settings
@onready var credits: Control = %Credits
@onready var input_key_v_box_container: VBoxContainer = %InputKeyVBoxContainer
@onready var star_resource = preload("res://ui/star.tscn")

func _ready() -> void:
	for i in 400:
		var star = star_resource.instantiate()
		star.position = Vector2(randi_range(0,1920),randi_range(0,1080))
		star.gen_range = 1080
		add_child(star)
	var tween_a = create_tween().set_loops()
	tween_a.tween_property(%Ball, "rotation", -1.0, 20.0).as_relative()
	var tween_b = create_tween().set_loops()
	tween_b.tween_property(%Radar, "rotation", 5.0, 2.0).as_relative()
	create_input_key_buttons()
	# Initialize settings panel position off screen to the right
	settings.position.x = get_viewport_rect().size.x
	credits.position.x = get_viewport_rect().size.x

func create_input_key_buttons() -> void:
	for key in INPUT_KEYS:
		var hbox = HBoxContainer.new()
		hbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL

		var label = Label.new()
		label.text = key
		label.add_theme_font_size_override('font_size', 40)
		label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		hbox.add_child(label)

		var button = Button.new()
		var button_text = "Click to bind"
		if InputMap.has_action(key):
			button_text = InputMap.action_get_events(key)[0].as_text()
		button.text = button_text
		button.custom_minimum_size.x = 120
		button.size_flags_horizontal = Control.SIZE_SHRINK_END
		button.pressed.connect(_on_key_bind_button_pressed.bind(button, key))
		hbox.add_child(button)

		input_key_v_box_container.add_child(hbox)

func _input(event: InputEvent) -> void:
	if is_rebinding_key:
		if event is InputEventKey:
			# Clear the existing key bindings for this action
			if InputMap.has_action(current_action_to_rebind):
				InputMap.action_erase_events(current_action_to_rebind)
			else:
				InputMap.add_action(current_action_to_rebind)

			# Add the new key binding
			InputMap.action_add_event(current_action_to_rebind, event)

			# Update the button text
			current_button_to_update.text = event.as_text()

			# Reset the rebinding state
			is_rebinding_key = false
			current_action_to_rebind = ""
			current_button_to_update = null

			# Consume the input event
			get_viewport().set_input_as_handled()

func _on_key_bind_button_pressed(button: Button, action_name: String) -> void:
	button.text = "Press any key..."
	is_rebinding_key = true
	current_action_to_rebind = action_name
	current_button_to_update = button

func _on_play_game_button_pressed() -> void:
	Global.load_game()

func _on_tutorial_button_pressed() -> void:
	Global.load_tutorial()

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _animate_menu_transition(main_x: float, settings_x: float) -> void:
	var tween = create_tween()
	tween.parallel().tween_property(main, "position:x", main_x, 0.3)
	tween.parallel().tween_property(settings, "position:x", settings_x, 0.3)
	tween.parallel().tween_property(credits, "position:x", settings_x, 0.3)

func _on_settings_button_pressed() -> void:
	settings.show()
	credits.hide()
	_animate_menu_transition(-get_viewport_rect().size.x, 0)

func _on_back_pressed() -> void:
	_animate_menu_transition(0, get_viewport_rect().size.x)

func _on_credits_button_pressed() -> void:
	settings.hide()
	credits.show()
	_animate_menu_transition(-get_viewport_rect().size.x, 0)
