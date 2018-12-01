extends Node2D

var active = false
var dude = null
var receiver = null
var organ = globals.ORGANS.BRAIN
var textures = {
	globals.ORGANS.BRAIN: preload("res://img/brain.png"),
	globals.ORGANS.HEART: preload("res://img/heart.png"),
	globals.ORGANS.LUNGS: preload("res://img/lungs.png"),
	globals.ORGANS.LIVER: preload("res://img/liver.png"),
	globals.ORGANS.LKIDNEY: preload("res://img/lkidney.png"),
	globals.ORGANS.RKIDNEY: preload("res://img/rkidney.png"),
}

func set(dude, organ):
	reset()
	self.active = true
	self.dude = dude
	self.organ = organ
	self.receiver = null
	$Sprite.texture = textures[organ]
	$Sprite.scale.x = 1
	$Sprite.scale.y = 1

func reset():
	active = false
	dude = null
	organ = 0
	receiver = null
	$Sprite.texture = null
	$FallAnimation.stop(true)

func maybe_receiver():
	if receiver != null:
		receiver.receive_organ(organ)
		reset()

func on_finished_falling():
	if receiver != null:
		receiver.receive_organ(organ)
	elif dude != null:
		dude.receive_organ(organ)
	reset()

func drop():
	if not $FallAnimation.is_playing():
		$FallAnimation.play("Fall")

func _process(delta):
	if active:
		if not Input.is_mouse_button_pressed(BUTTON_LEFT):
			drop()
		if not $FallAnimation.is_playing():
			$Sprite.position = get_viewport().get_mouse_position() * 0.5