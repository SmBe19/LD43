extends Node2D

signal buy_organ(organ)
signal sell_organ

var buying_organ = -1

const width = 180
const height = 180

func get_price(organ):
	return get_child(organ+1).price

func take_organ(organ):
	buying_organ = organ
	emit_signal("buy_organ", organ)
	
func sell_organ(organ):
	$"/root/Root/HUD".change_money(int(self.get_price(organ)* 0.4))

func _on_Surgery_start_puzzle():
	if buying_organ >= 0:
		$"/root/Root/HUD".change_money(-self.get_price(buying_organ))
		buying_organ = -1

func is_inside(position):
	if abs(position.x) < width/2 and abs(position.y) < height/2:
		return true
	return false

func _input(event):
	if event is InputEventMouseButton:
		var local_pos = get_local_mouse_position()
		if self.is_inside(local_pos):
			if not event.is_pressed():
				emit_signal("sell_organ")