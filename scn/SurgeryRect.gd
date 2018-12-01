extends Control

signal value_drop(x, y, value)

var can_change
var x
var y
var value setget value_set, value_get
var in_side = -1

func value_set(val):
	value = val
	match val:
		-1:
			$SurgeryPipe.texture = null
		0:
			$SurgeryPipe.texture = preload("res://img/pipe_vert.png")
			$SurgeryPipe.rect_rotation = 90
		1:
			$SurgeryPipe.texture = preload("res://img/pipe_vert.png")
			$SurgeryPipe.rect_rotation = 0
		2:
			$SurgeryPipe.texture = preload("res://img/pipe_turn.png")
			$SurgeryPipe.rect_rotation = 0
		3:
			$SurgeryPipe.texture = preload("res://img/pipe_turn.png")
			$SurgeryPipe.rect_rotation = 90
		4:
			$SurgeryPipe.texture = preload("res://img/pipe_turn.png")
			$SurgeryPipe.rect_rotation = 180
		5:
			$SurgeryPipe.texture = preload("res://img/pipe_turn.png")
			$SurgeryPipe.rect_rotation = 270

func value_get():
	return value
	
func get_drag_data(position):
	return -1

func can_drop_data(position, data):
	if data != -1:
		in_side = -1
	return can_change

func drop_data(position, data):
	if data >= 0:
		emit_signal("value_drop", x, y, data)
	
func get_nice_mouse_position():
	return get_local_mouse_position() - rect_size / 2

func get_mouse_side():
	var mouse_pos = get_nice_mouse_position()
	if abs(mouse_pos.x) > abs(mouse_pos.y):
		if mouse_pos.x > 0:
			return 0
		else:
			return 2
	else:
		if mouse_pos.y > 0:
			return 3
		else:
			return 1

func _on_SurgeryRect_mouse_entered():
	if can_change:
		if Input.is_mouse_button_pressed(BUTTON_LEFT) and in_side == -1:
			in_side = get_mouse_side()

func _on_SurgeryRect_mouse_exited():
	if can_change:
		if Input.is_mouse_button_pressed(BUTTON_LEFT) and in_side != -1:
			var out_side = get_mouse_side()
			if in_side != out_side:
				if out_side < in_side:
					var tmp = out_side
					out_side = in_side
					in_side = tmp
				var type = -1
				match in_side:
					0:
						match out_side:
							1:
								type = 5
							2:
								type = 0
							3:
								type = 2
					1:
						match out_side:
							2:
								type = 4
							3:
								type = 1
					2:
						match out_side:
							3:
								type = 3
				emit_signal("value_drop", x, y, type)
	in_side = -1
