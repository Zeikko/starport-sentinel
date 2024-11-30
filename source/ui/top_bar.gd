class_name TopBar extends Control


func show_message(message: String, duration: float) -> void:
	$Label.set_text(message)
	show()
	$Timer.stop()
	$Timer.wait_time = duration
	$Timer.start()


func _on_timer_timeout() -> void:
	hide()
