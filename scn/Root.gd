extends Node

func _ready():
	globals.death_speed = 1

func _process(delta):
	globals.death_speed += delta * globals.death_speed_acc
