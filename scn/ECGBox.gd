extends Sprite

var muted = false
var should_beep = false
var is_flat = false

func randomized_start(animation):
	$Flat.stop()
	should_beep = false
	is_flat = false
	$ECG.play(animation)
	$ECG.frame = randi()%$ECG.frames.get_frame_count(animation)
	var speed = 10 + randf() * 15
	$ECG.frames.set_animation_speed(animation, speed)

func alive():
	self.randomized_start("alive")
	should_beep = true

func flat():
	self.randomized_start("flat")
	is_flat = true
	$Flat.play()

func off():
	self.randomized_start("off")

func _process(delta):
	if should_beep and not muted:
		if $ECG.frame == 5:
			if not $Beep.playing:
				$Beep.play()

func _on_MuteButton_toggled(button_pressed):
	muted = button_pressed
	if muted:
		$Flat.stop()
		$Beep.stop()
	else:
		if is_flat:
			$Flat.play()
	
