extends Sprite

var muted = false
var should_beep = false
var is_flat = false
var speed = 15
var factor = 1
var last_seen = 0

func randomized_start(animation):
	$Flat.stop()
	should_beep = false
	is_flat = false
	$ECG.play(animation)
	$ECG.frame = randi()%$ECG.frames.get_frame_count(animation)
	speed = 10 + randf() * 15
	$ECG.frames.set_animation_speed(animation, speed)

func alive():
	self.randomized_start("alive")
	should_beep = true

func alive_faster(factor):
	if self.factor != factor:
		self.factor = factor
		$ECG.frames.set_animation_speed("alive", speed*factor)

func flat():
	self.randomized_start("flat")
	is_flat = true
	if not muted:
		$Flat.play()
	$VolumeAnimation.play("flat")

func off():
	self.randomized_start("off")

func _ready():
	var frames = $ECG.frames.duplicate()
	$ECG.frames = frames

func _process(delta):
	if should_beep and not muted:
		if last_seen < 5 && $ECG.frame >= 5:
			if $Beep.playing:
				$Beep.stop()
			$Beep.play()
		last_seen = $ECG.frame

func _on_MuteButton_toggled(button_pressed):
	muted = button_pressed
	if muted:
		$Flat.stop()
		$Beep.stop()
	else:
		if is_flat:
			$Flat.play()
	
