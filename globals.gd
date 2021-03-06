extends Node

enum ORGANS {BRAIN=0, HEART=1, LUNGS=2, LIVER=3, LKIDNEY=4, RKIDNEY=5}
const ORGAN_NAMES = [
	"brain",
	"heart",
	"lungs",
	"liver",
	"kidney",
	"kidney",
]

var organ_drag_drop_enabled = true

var game_time = 0

var death_speed = 1.1
var death_speed_acc = 0.002

var chop_difficulty = 1
var chop_level = 1

var money = 1000000
var score = 1000 setget score_set, score_get
var max_score = 0

var surgery_data = [-1, -1]

var tutorial = false

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
	score = 10
	max_score = 10
	tutorial = false

func start_game(tutorial=false):
	reset()
	fail_reason = ""
	self.tutorial = tutorial
	get_tree().change_scene("res://scn/Root.tscn")
	
func end_menu(fail=""):
	fail_reason = fail
	get_tree().change_scene("res://scn/EndMenu.tscn")

func main_menu():
	get_tree().change_scene("res://scn/MainMenu.tscn")

func exit_game():
	get_tree().quit()