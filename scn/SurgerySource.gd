extends TextureRect

var value setget value_set, value_get

func value_set(val):
	value = val
	match val:
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
	set_drag_preview(self.duplicate())
	return value