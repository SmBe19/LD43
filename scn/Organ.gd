tool
extends Node2D

signal take_organ(organ)
signal drop_organ(organ)

enum ORGANS {BRAIN, HEART, LUNGS, LIVER, LKIDNEY, RKIDNEY}

export(Texture) var texture
export(BitMap) var click_mask
export(bool) var mirror
export(ORGANS) var organ_type

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
	$Sprite.scale.x = -1 if mirror else 1
	$ButtonTakeOrgan.texture_click_mask = click_mask

func get_drag_data(position):
	if not present:
		return null
	emit_signal("take_organ", organ_type)
	return organ_type

func can_drop_data(position, data):
	return data == organ_type and not present

func drop_data(position, data):
	emit_signal("drop_organ", organ_type)
