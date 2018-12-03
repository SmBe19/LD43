extends Node

func pause():
	get_tree().paused = true

func unpause():
	get_tree().paused = false

func _ready():
	if not globals.tutorial:
		return
	pause()
	_on_WelcomeNext_pressed()

func welcome_finished():
	unpause()
	$Welcome/MoveInTimer.start()

func welcome2_finished():
	unpause()
	$"../GameRoot/Belts".connect_belt_dudes(self, "on_take_organ", "on_drop_organ", "on_start_chop")
	$"../GameRoot/ChopChop".connect("chop_finished", self, "on_chop_finished")

func on_take_organ(dude, organ):
	pass

var drop_done = false

func on_drop_organ(dude, organ):
	if not drop_done:
		$Welcome/MoveInTimer.wait_time = 1
		$Welcome/MoveInTimer.start()
		drop_done = true

var chop_start_done = false

func on_start_chop(dude):
	if not chop_start_done:
		$Welcome/MoveInTimer.wait_time = 1
		$Welcome/MoveInTimer.start()
		chop_start_done = true

var chop_finished_done = false

func on_chop_finished():
	if not chop_finished_done:
		$Welcome/MoveInTimer.wait_time = 1
		$Welcome/MoveInTimer.start()
		chop_finished_done = true

var next_welcome = 0

func _on_WelcomeNext_pressed():
	$Welcome/WelcomeAnimation.play("Step" + str(next_welcome))
	print("start step ", next_welcome)
	next_welcome += 1

func _on_MoveInTimer_timeout():
	pause()
	_on_WelcomeNext_pressed()
