class_name TimeTracker extends Object

var shift_in_progress : bool
var shift_duration : float = 0
var total_duration : float = 0
var shift_duration_history : Array[float] = []

func uptade_timetracker(delta : float)-> void:
	if shift_in_progress == false:
		shift_duration += 1 * delta	
		
func end_shift()-> void :
	shift_in_progress = false
	total_duration += shift_duration
	shift_duration_history.push_back(shift_duration)
	
func start_shift()-> void :
	shift_duration = 0
	shift_in_progress = true

func show_label(shift_duration_label : Label, total_duration_label : Label )-> void:
	shift_duration_label.set_text('Shift Time: ' + str(round(shift_duration * 10) /10.0))
	total_duration_label.set_text('Total Time: ' + str(round(total_duration * 10) /10.0))
