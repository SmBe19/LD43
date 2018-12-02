extends Node

func _ready():
	globals.reset()

func _process(delta):
	globals.death_speed += delta * globals.death_speed_acc
	globals.game_time += delta
	globals.chop_difficulty = int(ceil(globals.game_time / 20))
