extends Node

func _ready():
	if not globals.tutorial:
		remove_child($Tutorial)

func _process(delta):
	globals.death_speed += delta * globals.death_speed_acc
	globals.game_time += delta
	globals.chop_difficulty = int(ceil(globals.game_time / 20))

func _input(event):
	if event.is_action("ui_cancel"):
		if OS.get_name() != "HTML5":
			get_tree().set_input_as_handled()
			globals.end_menu("I can't do this anymore!")
