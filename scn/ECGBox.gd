extends Sprite

var should_beep = false

func randomized_start(animation):
	$Flat.stop()
	should_beep = false
	$ECG.play(animation)
	$ECG.frame = randi()%$ECG.frames.get_frame_count(animation)
	var speed = 10 + randf() * 15
	$ECG.frames.set_animation_speed(animation, speed)

func alive():
	self.randomized_start("alive")
	should_beep = true

func flat():
	self.randomized_start("flat")
	$Flat.play()

func off():
	self.randomized_start("off")

func _process(delta):
	if should_beep:
		if $ECG.frame == 5:
			if not $Beep.playing:
				$Beep.play()