class_name TimeTracker extends Object

var shift_in_progress : bool
var shift_duration : float = 0
var total_duration : float = 0


func update_timetracker(delta : float)-> void:
	if shift_in_progress == true:
		shift_duration += delta

func end_shift()-> void :
	shift_in_progress = false
	total_duration += shift_duration

func start_shift()-> void :
	shift_duration = 0
	shift_in_progress = true

func show_label(shift_duration_label : Label, total_duration_label : Label )-> void:
	shift_duration_label.set_text('Shift Time: ' + seconds_to_mm_ss(shift_duration))
	total_duration_label.set_text('Total Time: ' + seconds_to_mm_ss(total_duration))

func seconds_to_mm_ss(arg_seconds: float)-> String:
	var minutes: int = floor(arg_seconds / 60)
	var seconds: int = floor(arg_seconds - minutes * 60)
	var mm_ss: String = str(
	'0' if str(minutes).length() == 1 else '',
	minutes,
	':',
	'0' if str(seconds).length() == 1 else '',
	seconds
	)
	return mm_ss
