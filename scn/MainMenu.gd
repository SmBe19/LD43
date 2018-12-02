extends Node

func _on_btn_red_pressed():
	globals.exit_game()

func _on_btn_green_pressed():
	globals.start_game()

func _ready():
	$FailReason.text = globals.fail_reason