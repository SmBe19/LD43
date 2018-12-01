extends Node2D

export(float) var moving_speed = 182

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
	$NextDude.randomize_organs()

func stop_moving():
	offset = 0
	moving = false
	$Dude.scale.x = 1
	$Dude.scale.y = 1
	$Dude.copy_organs($NextDude)
	$"/root/Root/HUD".subtract_waiting()

func hide_dude():
	$Dude.scale.x = 0
	$Dude.scale.y = 0

func can_do_action():
	return not $KillAnimation.is_playing() and not moving

func start_killing():
	$KillAnimation.play("Kill");

func kill_finished():
	self.start_moving()

func _ready():
	randomize()
	self.apply_offset()
	$Dude.randomize_organs()

func _process(delta):
	if moving:
		offset += delta * moving_speed
		if offset > height:
			self.stop_moving()
		self.apply_offset()

func _on_ButtonNext_pressed():
	if self.can_do_action():
		self.start_moving()
		$"/root/Root/HUD".change_score($Dude.get_score())

func _on_ButtonKill_pressed():
	if self.can_do_action():
		self.start_killing()
		$"/root/Root/HUD".change_score(-1)
