class_name Tutorial extends Node2D

enum Step {
	SELECT_SHIP,
	SCAN_SHIP,
	APPROVE_SHIP,
	REJECT_SHIP,
	FINISH_SHIFT,
	REJECT_DANGEROUS_SHIP,
	OPEN_HELP,
	COMPLETE
}
var current_step: Step:
	set (value):
		current_step = value
		update_instructions()
var enabled: bool = false:
	set(value):
		enabled = value
		visible = value

func _ready() -> void:
	Global.tutorial = self
	update_instructions()


func complete(arg_step: Step) -> void:
	if enabled:
		if current_step == arg_step:
			current_step += 1
			Global.ui.top_bar.show_message('great work!', 3)
		if current_step == Step.COMPLETE:
			enabled = false

func update_instructions() -> void:
	match current_step:
		Step.SELECT_SHIP:
			%Instructions.set_text('Select a ship by clicking a radar blip')
		Step.SCAN_SHIP:
			%Instructions.set_text(str(
				'Scan ship by clicking the scan button. ',
				'It is advised to scan ships with suspiciously low amount of cargo ',
				'because they might not have declared all of their cargo'
			))
		Step.APPROVE_SHIP:
			%Instructions.set_text(str(
				'Approve a ship which does not violate any of the security rules. ',
				'by pressing the approve button. ',
				'Approved ships will visit your starport and earn you credits.'
				))
		Step.REJECT_SHIP:
			%Instructions.set_text(str(
				'Reject a ship by pressing the reject button. ',
				'You can change your mind and approve it afterwards.'
			))
		Step.FINISH_SHIFT:
			%Instructions.set_text('Finish shift by rejecting or approving all the ships')
		Step.REJECT_DANGEROUS_SHIP:
			%Instructions.set_text(str(
				'Find a ship which violates a security rule and reject it. ',
				'Remember that any information on the left side of the screen can be false ',
				'If dangerous ships are approved into your starport they will deal damage.'
			))
		Step.OPEN_HELP:
			%Instructions.set_text(str(
				'Click HELP button in the top right corner in order to learn more.'
			))
