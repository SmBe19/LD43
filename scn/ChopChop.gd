extends Node2D

signal chop_finished
signal chop_failed

const chops = [
	preload("res://img/chopchop/chop1.png"),
	preload("res://img/chopchop/chop2.png"),
	preload("res://img/chopchop/chop3.png"),
	preload("res://img/chopchop/chop4.png"),
	preload("res://img/chopchop/chop5.png"),
	preload("res://img/chopchop/chop6.png"),
	preload("res://img/chopchop/chop7.png"),
]

var cur_chop = -1
var cut_path = null
var cut_path_tex = null
var was_down = false
var fine_used = 0

var chop_pos

const width = 192
const height = 144
const chop_speed = 30
const border = 5
const its_fine = [0, 30, 200]

func start_chop():
	reset()
	cur_chop = randi()%len(chops)
	$Wrapper/Path.texture = chops[cur_chop]
	visible = true
	was_down = false
	globals.organ_drag_drop_enabled = false
	$ShowHideAnimation.play("Show")
	$Wrapper/tol/scalpel.visible = globals.chop_level == 1
	$Wrapper/tol/saw.visible = globals.chop_level == 2
	$Wrapper/tol/saw.playing = globals.chop_level == 2

func hide_finished():
	visible = false

func _ready():
	self.start_chop()

func mouse_pos():
	var pos = get_local_mouse_position()
	return Vector2(int(pos.x/2 + width/2), int(pos.y/2 + height/2))

func finish_chopping(result):
	globals.organ_drag_drop_enabled = true
	$ShowHideAnimation.play("Hide")
	emit_signal(result)
	cur_chop = -1

func reset():
	fine_used = 0
	$Wrapper/CutPath.texture = null

func draw(old_pos, new_pos):
	var dir = (new_pos - old_pos).normalized()
	var steps = ceil((new_pos - old_pos).length() / dir.length()) if dir.length() > 0 else 1
	var path_tex = chops[cur_chop].get_data()
	cut_path.lock()
	path_tex.lock()
	for i in range(steps):
		var pos = old_pos + (i+1) * dir
		if 0 <= pos.x and pos.x < width and 0 <= pos.y and pos.y < height:
			cut_path.set_pixel(pos.x, pos.y, Color(1, 0, 0, 1))
			var col = path_tex.get_pixel(pos.x, pos.y)
			if col.r == 0:
				fine_used += 1
				if fine_used > its_fine[globals.chop_level]:
					finish_chopping("chop_failed")
	path_tex.unlock()
	cut_path.unlock()
	cut_path_tex.set_data(cut_path)

func update_chop(delta):
	var new_pos = mouse_pos()
	var old_pos = chop_pos
	if globals.chop_level == 2:
		chop_pos = new_pos
	else:
		var diff = new_pos - chop_pos
		var normed = diff.normalized()
		var speeded = normed * chop_speed * delta
		if speeded.length() > diff.length():
			speeded = diff
		chop_pos = chop_pos + speeded
	draw(old_pos, chop_pos)
	$Wrapper/tol.position = chop_pos * 2

func check_chop():
	var path_tex = chops[cur_chop].get_data()
	cut_path.lock()
	path_tex.lock()
	var in_range = false
	var found = 0
	for y in [0, height-1]:
		for x in range(width):
			if path_tex.get_pixel(x, y).r == 1:
				if not in_range:
					if y == 0:
						for yy in range(border):
							if cut_path.get_pixel(x, yy).r == 1:
								if not in_range:
									found += 1
								in_range = true
					else:
						for yy in range(height-border-1, height):
							if cut_path.get_pixel(x, yy).r == 1:
								if not in_range:
									found += 1
								in_range = true
			else:
				in_range = false
	for x in [0, width-1]:
		for y in range(height):
			if path_tex.get_pixel(x, y).r == 1:
				if not in_range:
					if x == 0:
						for xx in range(border):
							if cut_path.get_pixel(xx, y).r == 1:
								if not in_range:
									found += 1
								in_range = true
					else:
						for xx in range(width-border-1, width):
							if cut_path.get_pixel(xx, y).r == 1:
								if not in_range:
									found += 1
								in_range = true
			else:
				in_range = false
	path_tex.unlock()
	cut_path.unlock()
	if found == 2:
		finish_chopping("chop_finished")

func _process(delta):
	if cur_chop != -1:
		var is_down = Input.is_mouse_button_pressed(BUTTON_LEFT)
		if not was_down and is_down:
			cut_path = Image.new()
			cut_path.create(width, height, false, Image.FORMAT_RGBAF)
			cut_path_tex = ImageTexture.new()
			cut_path_tex.create(width, height, Image.FORMAT_RGBAF, 0)
			cut_path_tex.set_data(cut_path)
			$Wrapper/CutPath.texture = cut_path_tex
			
			chop_pos = mouse_pos()
		if was_down and not is_down:
			check_chop()
			reset()
		
		if is_down:
			update_chop(delta)
		else:
			$Wrapper/tol.position = mouse_pos() * 2
			
		was_down = is_down
	