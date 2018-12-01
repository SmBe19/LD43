extends Node2D

export(float) var moving_speed = 32

var moving = false
var offset = 0

onready var belt_off = $BeltSprite.position.y
onready var dude_off = $Dude.position.y
onready var next_dude_off = $NextDude.position.y

const height = 400
const belt_size = 80

func apply_offset():
	var offset_nice = int(floor(offset))
	$BeltSprite.position.y = offset_nice % belt_size + belt_off
	$Dude.position.y = offset_nice + dude_off
	$NextDude.position.y = offset_nice + next_dude_off

func start_moving():
	moving = true

func _reade():
	self.apply_offset()

func _process(delta):
	if moving:
		offset += delta * moving_speed
		if offset > height:
			offset = 0
			moving = false
		self.apply_offset()