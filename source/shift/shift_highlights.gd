class_name ShiftHighlights extends Node

var shift_highlights = {
	'Total ships' : 0.0,
	'Dangerous ships' : 0.0,
	'Credits gaind' : 0.0,
	'Shift duration' :0.0 }

func _init(arg_total_ships, arg_dangerous_ships, arg_credits_gaind, arg_shift_duration) -> void:
	var keys = shift_highlights.keys()
	shift_highlights['Total ships'] = arg_total_ships
	shift_highlights['Dangerous ships'] = arg_dangerous_ships
	shift_highlights['Credits gaind'] = arg_credits_gaind
	shift_highlights['Shift duration'] = arg_shift_duration

func get_label(item_index: int)-> Label:
	var label: Label = Label.new()
	var keys = shift_highlights.keys()
	if item_index >= 0 and item_index < keys.size():
		var key = keys[item_index]
		label.set_text(key + ": " + str(round(shift_highlights[key] * 10 )/10))
	return label
