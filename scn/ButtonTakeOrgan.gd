extends TextureButton

func get_drag_data(position):
	return $"..".get_drag_data(position)

func can_drop_data(position, data):
	return $"..".can_drop_data(position, data)

func drop_data(position, data):
	$"..".drop_data(position, data)
