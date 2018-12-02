extends Node2D

export(float) var moving_speed = 182

var moving = false
var score_change = 0
var feedback_text = ""
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
	$ECGBox/ECG.play("off")
	score_change = 0
	feedback_text = ""
	moving = true
	$NextDude.randomize_organs()
	$"/root/Root/HUD".subtract_waiting()

func stop_moving():
	if score_change != 0:
		$"/root/Root/HUD".change_score(score_change)
		if score_change > 0:
			$"/root/Root/HUD".change_money(score_change*10)
	if feedback_text != "":
		$Complaint/ComplaintText.text = feedback_text
		$Complaint.visible = true
		$Complaint/ComplaintTimer.start()
	offset = 0
	moving = false
	$Dude.scale.x = 1
	$Dude.scale.y = 1
	$Dude.copy_organs($NextDude)
	self.playECG("alive")

func playECG(animation):
	$ECGBox/ECG.play(animation)
	$ECGBox/ECG.frame = randi()%$ECGBox/ECG.frames.get_frame_count(animation)
	$ECGBox/ECG.frames.set_animation_speed(animation, 10 + randf() * 15)

func hide_dude():
	$Dude.scale.x = 0
	$Dude.scale.y = 0

func can_do_action():
	return not $KillAnimation.is_playing() and not moving

func start_killing():
	$ECGBox/ECG.play("off")
	$KillAnimation.play("Kill");
	if randf() < 0.1:
		$"/root/Root/GameRoot".add_blood()

func kill_finished():
	self.start_moving()
	$"/root/Root/HUD".change_score(-1)

func _ready():
	$Complaint.visible = false
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
		score_change = $Dude.get_score()
		feedback_text = $Dude.get_feedback_text()

func _on_ButtonKill_pressed():
	if self.can_do_action():
		self.start_killing()

func _on_ComplaintTimer_timeout():
	$Complaint.visible = false
