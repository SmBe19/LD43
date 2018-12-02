extends Node

enum ORGANS {BRAIN=0, HEART=1, LUNGS=2, LIVER=3, LKIDNEY=4, RKIDNEY=5}

var organ_drag_drop_enabled = true

var game_time = 0

var death_speed = 1
var death_speed_acc = 0.02

var chop_difficulty = 1
var chop_level = 1

var money = 1000000
var score = 1000 setget score_set, score_get
var max_score = 0

var fail_reason = "fired for low self-esteem"

func score_set(val):
	score = val
	max_score = max(max_score, val)

func score_get():
	return score

func reset():
	organ_drag_drop_enabled = true
	game_time = 0
	death_speed = 1
	chop_difficulty = 1
	chop_level = 1
	money = 250
	score = 20
	max_score = 20

func start_game():
	reset()
	get_tree().change_scene("res://scn/Root.tscn")
	fail_reason = ""
	
func end_menu(fail=""):
	fail_reason = fail
	get_tree().change_scene("res://scn/EndMenu.tscn")

func main_menu():
	get_tree().change_scene("res://scn/MainMenu.tscn")

func exit_game():
	get_tree().quit()