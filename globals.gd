extends Node

enum ORGANS {BRAIN=0, HEART=1, LUNGS=2, LIVER=3, LKIDNEY=4, RKIDNEY=5}

var organ_drag_drop_enabled = true

var game_time = 0

var death_speed = 1
var death_speed_acc = 0.01

var chop_difficulty = 1
var chop_level = 1

var money = 0
var score = 0

var fail_reason = ""

func reset():
	organ_drag_drop_enabled = true
	game_time = 0
	death_speed = 1
	chop_difficulty = 1
	chop_level = 1
	money = 250
	score = 20

func start_game():
	reset()
	get_tree().change_scene("res://scn/Root.tscn")
	fail_reason = ""

func main_menu(fail=""):
	fail_reason = fail
	get_tree().change_scene("res://scn/MainMenu.tscn")

func exit_game():
	get_tree().quit()