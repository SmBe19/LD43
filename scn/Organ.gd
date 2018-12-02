tool
extends Node2D

signal take_organ(organ)
signal drop_organ(organ)

enum ORGANS {BRAIN=0, HEART=1, LUNGS=2, LIVER=3, LKIDNEY=4, RKIDNEY=5}

export(ORGANS) var organ_type = ORGANS.BRAIN
export(int) var price = 0
export(bool) var use_blood = true

const textures = [
	preload("res://img/brain.png"),
	preload("res://img/heart.png"),
	preload("res://img/lungs.png"),
	preload("res://img/liver.png"),
	preload("res://img/lkidney.png"),
	preload("res://img/rkidney.png"),
]

const width = 64
const height = 64

var present = false setget present_set, present_get
var alive = false setget alive_set, alive_get

func get_modulate():
	if not present:
		return Color(0.2, 0.2, 0.2, 0.2)
	elif not alive:
		return Color(0.1, 0.2, 0, 0.5)
	else:
		return Color(1, 1, 1, 1)

func present_set(val):
	present = val
	$Sprite.modulate = get_modulate()

func present_get():
	return present

func alive_set(val):
	alive = val
	$Sprite.modulate = get_modulate()

func alive_get(val):
	return alive

func _ready():
	$Sprite.texture = textures[organ_type]
	$PriceBG.visible = price > 0
	$PriceLabel.text = "$ " + str(price) + "k"
	$PriceLabel.visible = price > 0

func should_accept_input(position):
	var image = textures[organ_type].get_data()
	image.lock()
	var pixel = image.get_pixel(int(position.x), int(position.y))
	image.unlock()
	return pixel.a > 0.2

func is_inside(position):
	if abs(position.x) < width/2 and abs(position.y) < height/2:
		return true
	return false
	
func can_buy():
	if price > 0:
		return get_node("/root/globals").money >= price
	return true

func do_blood():
	if use_blood:
		$bloodParticles.restart()

func to_nice_local(position):
	return position + Vector2(width/2, height/2)

func _input(event):
	if Engine.editor_hint:
		return
	if get_node("/root/globals") and not get_node("/root/globals").organ_drag_drop_enabled:
		return
	if not visible:
		return
	if event is InputEventMouseButton:
		if self.can_buy():
			var local_pos = get_local_mouse_position()
			if self.is_inside(local_pos):
				var nice_local_pos = self.to_nice_local(local_pos)
				if self.should_accept_input(nice_local_pos):
					if event.is_pressed():
						emit_signal("take_organ", organ_type)
						self.do_blood()
					else:
						emit_signal("drop_organ", organ_type)