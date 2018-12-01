extends Node

export(int) var start_belt = 2
export(int) var max_belt = 6

const center = 320
const belt_width = 100

var belt = preload("res://scn/Belt.tscn")

func distribute_belts():
	var belt_count = $Belts.get_child_count()
	var total_width = belt_count * belt_width
	var left = center - total_width / 2
	left = floor(left/2)*2
	var belt_off = floor(belt_width / 4) * 2
	for i in range(belt_count):
		var belt = $Belts.get_child(i)
		belt.position.x = left + i * belt_width + belt_off
	

func _ready():
	for i in range(start_belt-1):
		$Belts.add_child(belt.instance())
	self.distribute_belts()

func _unhandled_input(event):
	if event is InputEventKey:
		if event.scancode == KEY_SPACE:
			for i in range($Belts.get_child_count()):
				$Belts.get_child(i).start_moving()

#func _process(delta):
#	pass
