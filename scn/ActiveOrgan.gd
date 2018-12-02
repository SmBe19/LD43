extends Node2D

var active = false
var dude = null
var receiver = null
var organ = -1
var textures = {
	globals.ORGANS.BRAIN: preload("res://img/brain.png"),
	globals.ORGANS.HEART: preload("res://img/heart.png"),
	globals.ORGANS.LUNGS: preload("res://img/lungs.png"),
	globals.ORGANS.LIVER: preload("res://img/liver.png"),
	globals.ORGANS.LKIDNEY: preload("res://img/lkidney.png"),
	globals.ORGANS.RKIDNEY: preload("res://img/rkidney.png"),
}
const entries = [6, 4, 4, 2, 2, 2]

func set(dude, organ):
	if dude != null and active:
		dude.receive_organ(self.organ)
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
	organ = -1
	receiver = null
	$Sprite.texture = null
	$FallAnimation.stop(true)

func maybe_receiver():
	if receiver != null and receiver != dude:
		$FallAnimation.stop()
		$"../Surgery".start_surgery(entries[organ], 2)

func on_finished_falling():
	if receiver != null:
		receiver.receive_organ(organ)
	elif dude != null:
		dude.receive_organ(organ)
	reset()

func drop():
	active = false
	if not $FallAnimation.is_playing():
		$FallAnimation.play("Fall")

func _process(delta):
	if active:
		if not Input.is_mouse_button_pressed(BUTTON_LEFT):
			drop()
		$Sprite.position = get_viewport().get_mouse_position() * 0.5

func _on_Surgery_failed_puzzle():
	if receiver != null:
		receiver.die()
	self.reset()

func _on_Surgery_finished_puzzle():
	if receiver != null:
		receiver.receive_organ(organ)
	self.reset()