extends Node2D

signal finished_puzzle
signal failed_puzzle
signal start_puzzle

const width = 8
const height = 6

var field
var rects
const pipe_colors = [
	Color(1, 0, 0),
	Color(0, 0, 1),
	Color(0, 1, 0),
]

func start_surgery(entries, colors):
	globals.organ_drag_drop_enabled = false
	visible = true
	self.randomize_field(entries, colors)
	emit_signal("start_puzzle")
	$ShowHideAnimation.play("Show")

func finish_surgery(result):
	globals.organ_drag_drop_enabled = true
	$ShowHideAnimation.play("Hide")
	emit_signal(result)
	
func hiding_finished():
	visible = false

func _ready():
	self.generate_field()
	self.randomize_field(1, 1)

func is_border(x, y):
	return x == 0 or x == width - 1 or y == 0 or y == height - 1

func is_valid(x, y):
	return x >= 0 and x < width and y >= 0 and y < height

func generate_field():
	var source_order = [1, 0, 4, 5, 2, 3]
	for i in range(6):
		var new_child = preload("res://scn/SurgerySource.tscn").instance()
		new_child.value = i
		new_child.rect_position = Vector2(0, source_order[i] * 48)
		$Source.add_child(new_child)
	rects = []
	for y in range(height):
		var row = []
		for x in range(width):
			var new_child = preload("res://scn/SurgeryRect.tscn").instance()
			new_child.value = -1
			new_child.x = x
			new_child.y = y
			new_child.rect_position = Vector2(x * 48, y * 48)
			new_child.can_change = not is_border(x, y)
			new_child.connect("value_drop", self, "value_drop")
			$Wrapper.add_child(new_child)
			row.append(new_child)
		rects.append(row)

func value_drop(x, y, value):
	field[y][x] = value
	rects[y][x].value = value
	self.check_field()

func rand_border_pos():
	var x = -1
	var y = -1
	for j in range(100):
		if randi()%2 == 0:
			x = 0 if randi()%2 == 0 else width - 1
			y = randi()%(height - 2) + 1
		else:
			x = randi()%(width - 2) + 1
			y = 0 if randi()%2 == 0 else height - 1
		if field[y][x] == -1:
			break
	return [x, y]

func get_main_dir(x, y, dest):
	if abs(dest[0] - x) > abs(dest[1] - y):
		return [sign(dest[0] - x), 0]
	else:
		return [0, sign(dest[1] - y)]

func add_random_walk(color):
	for i in range(100):
		var start = rand_border_pos()
		var dest = rand_border_pos()
		if start == dest:
			continue
		var path = [start]
		var dirs = [[-1, 0], [1, 0], [0, -1], [0, 1]]
		var x = start[0]
		var y = start[1]
		for dir in dirs:
			var nx = x + dir[0]
			var ny = y + dir[1]
			if is_valid(nx, ny) and not is_border(nx, ny) and field[ny][nx] == -1:
				x = nx
				y = ny
				path.append([nx, ny])
		if len(path) == 1:
			continue
		var main_dir = get_main_dir(x, y, dest)
		while true:
			var nx = x + main_dir[0]
			var ny = y + main_dir[1]
			if nx == dest[0] and ny == dest[1]:
				path.append(dest)
				for p in path:
					field[p[1]][p[0]] = 1
					rects[p[1]][p[0]].modulate = color
				return
			if is_valid(nx, ny) and not is_border(nx, ny) and field[ny][nx] == -1 and not [nx, ny] in path:
				x = nx
				y = ny
			else:
				var found_dir = false
				for dir in dirs:
					nx = x + dir[0]
					ny = y + dir[1]
					if is_valid(nx, ny) and not is_border(nx, ny) and field[ny][nx] == -1 and not [nx, ny] in path:
						x = nx
						y = ny
						found_dir = true
						break
				if not found_dir:
					break
			path.append([x, y])
			main_dir = get_main_dir(x, y, dest)

func randomize_field(entries, colors):
	field = []
	for y in range(height):
		var row = []
		for x in range(width):
			row.append(-1)
			rects[y][x].modulate = Color(1, 1, 1)
		field.append(row)
	var colidx = 0
	for i in range(entries):
		add_random_walk(pipe_colors[colidx])
		colidx = (colidx+1)%colors
	for y in range(height):
		for x in range(width):
			if not is_border(x, y):
				field[y][x] = -1
				rects[y][x].modulate = Color(1, 1, 1)
			elif field[y][x] == 1:
				if x == 0 or x == width - 1:
					field[y][x] = 0
			rects[y][x].value = field[y][x]

func color_path(start_x, start_y, fld, col, ignore_coldiff=false):
	var x = start_x
	var y = start_y
	fld[y][x] = 1
	if ignore_coldiff:
		rects[y][x].modulate = col
	while true:
		var dir
		if field[y][x] == -1:
			return true
		var nx
		var ny
		var dirss = [
			[[-1, 0], [1, 0]],
			[[0, -1], [0, 1]],
			[[1, 0], [0, 1]],
			[[0, 1], [-1, 0]],
			[[-1, 0], [0, -1]],
			[[0, -1], [1, 0]],
		]
		var dirs = dirss[field[y][x]]
		var found_dir = false
		for dir in dirs:
			nx = x + dir[0]
			ny = y + dir[1]
			if is_valid(nx, ny) and fld[ny][nx] == 0 and field[ny][nx] != -1:
				var odirs = dirss[field[ny][nx]]
				var pos = false
				for odir in odirs:
					var nnx = nx + odir[0]
					var nny = ny + odir[1]
					if nnx == x and nny == y:
						pos = true
				if not pos:
					continue
				x = nx
				y = ny
				fld[y][x] = 1
				if not ignore_coldiff and is_border(x, y):
					if rects[y][x].modulate != col:
						for y in range(height):
							for x in range(width):
								fld[y][x] = 0
						color_path(start_x, start_y, fld, Color(0.3, 0.7, 0.2, 1), true)
						return false
				rects[y][x].modulate = col
				found_dir = true
				break
		if not found_dir:
			break
	return true

func check_field():
	var fld = []
	var bord = []
	for y in range(height):
		var row = []
		for x in range(width):
			if field[y][x] != -1 and self.is_border(x, y):
				bord.append([x, y])
			if not self.is_border(x, y):
				rects[y][x].modulate = Color(1, 1, 1)
			row.append(0)
		fld.append(row)
	var starts = 0
	for brd in bord:
		var x = brd[0]
		var y = brd[1]
		if fld[y][x] == 1:
			continue
		starts += 1
		var col = rects[y][x].modulate
		if not self.color_path(x, y, fld, col, false):
			finish_surgery("failed_puzzle")
			return
	if starts == len(bord)/2:
		finish_surgery("finished_puzzle")
