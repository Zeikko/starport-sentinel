class_name TimeTracker extends Object

var shift_in_progress : bool
var shift_duration : float = 0
var total_duration : float = 0


func update_timetracker(delta : float)-> void:
	if shift_in_progress == true:
		shift_duration += 1 * delta	
		
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
	var seconds: int = round(arg_seconds)
	var str_time: String = str(int(seconds / 600))+str(int((int(seconds) / 60) %10))+':'+ str(int((seconds % 60) /10))+str(int(seconds % 60) %10)
	return str_time
