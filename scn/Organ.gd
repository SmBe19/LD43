tool
extends Node2D

signal take_organ(organ)
signal drop_organ(organ)

enum ORGANS {BRAIN, HEART, LUNGS, LIVER, LKIDNEY, RKIDNEY}

export(Texture) var texture
export(ORGANS) var organ_type

const width = 64
const height = 64

var present = false setget present_set, present_get

func get_modulate(active):
	if active:
		return Color(1, 1, 1, 1)
	else:
		return Color(0.2, 0.2, 0.2, 1)

func present_set(val):
	present = val
	modulate = get_modulate(val)

func present_get():
	return present

func _ready():
	$Sprite.texture = texture

func should_accept_input(position):
	var image = texture.get_data()
	image.lock()
	var pixel = image.get_pixel(int(position.x), int(position.y))
	image.unlock()
	return pixel.a > 0.2

func is_inside(position):
	if abs(position.x) < width/2 and abs(position.y) < height/2:
		return true
	return false

func to_nice_local(position):
	return position + Vector2(width/2, height/2)

func _input(event):
	if event is InputEventMouseButton:
		var local_pos = get_local_mouse_position()
		if self.is_inside(local_pos):
			var nice_local_pos = self.to_nice_local(local_pos)
			if self.should_accept_input(nice_local_pos):
				if event.is_pressed():
					emit_signal("take_organ", organ_type)
				else:
					emit_signal("drop_organ", organ_type)