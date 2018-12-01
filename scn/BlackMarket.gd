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
	$"/root/Root/HUD".change_money(int(self.get_price(organ)* 0.5))

func _on_Surgery_start_puzzle():
	if buying_organ >= 0:
		$"/root/Root/HUD".change_money(-self.get_price(buying_organ))
		buying_organ = -1

func is_inside(position):
	if abs(position.x) < width/2 and abs(position.y) < height/2:
		return true
	return false

func _input(event):
	if not globals.organ_drag_drop_enabled:
		return
	if event is InputEventMouseButton:
		var local_pos = get_local_mouse_position()
		if self.is_inside(local_pos):
			if not event.is_pressed():
				emit_signal("sell_organ")

func belt_price():
	return [0, 0, 1000, 5000, 20000, 100000, -1, -1, -1][$"../Belts".get_child_count()]

func set_belt_price():
	$beltWrapper/beltPrice.text = "$ " + str(belt_price()/1000) + "M"

func _ready():
	self.set_belt_price()

func _on_belt_pressed():
	if $"/root/Root/HUD".change_money(-belt_price()):
		$"../Belts".add_belt()
		self.set_belt_price()
		if self.belt_price() < 0:
			$beltWrapper.visible = false
