extends TextureRect

signal value_drop(x, y, value)

var can_change
var x
var y
var value setget value_set, value_get

func value_set(val):
	value = val
	match val:
		-1:
			texture = null
		0:
			texture = preload("res://img/pipe_vert.png")
			rect_rotation = 90
		1:
			texture = preload("res://img/pipe_vert.png")
			rect_rotation = 0
		2:
			texture = preload("res://img/pipe_turn.png")
			rect_rotation = 0
		3:
			texture = preload("res://img/pipe_turn.png")
			rect_rotation = 90
		4:
			texture = preload("res://img/pipe_turn.png")
			rect_rotation = 180
		5:
			texture = preload("res://img/pipe_turn.png")
			rect_rotation = 270

func value_get():
	return value

func get_drag_data(position):
	if can_change:
		var val = value
		self.value = -1
		if val >= 0:
			set_drag_preview($"../../Source".get_child(val).duplicate())
			return val
	return null

func can_drop_data(position, data):
	return can_change

func drop_data(position, data):
	emit_signal("value_drop", x, y, data)
