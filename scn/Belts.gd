extends Node2D

export(int) var start_belt = 2
export(int) var max_belt = 6

const center = 320
const belt_width = 100

var belt = preload("res://scn/Belt.tscn")

func distribute_belts():
	var belt_count = self.get_child_count()
	var total_width = belt_count * belt_width
	var left = center - total_width / 2
	left = floor(left/2)*2
	var belt_off = floor(belt_width / 4) * 2
	for i in range(belt_count):
		var belt = self.get_child(i)
		belt.position.x = left + i * belt_width + belt_off
	self.connect_belt_dudes($"..", "on_take_organ", "on_drop_organ", "on_start_chop")

func connect_belt_dudes(instance, functiontake, functiondrop, functionchop):
	for i in range(self.get_child_count()):
		var dude = self.get_child(i).get_node("Dude")
		if not dude.is_connected("take_organ_from_dude", instance, functiontake):
			dude.connect("take_organ_from_dude", instance, functiontake)
		if not dude.is_connected("drop_organ_to_dude", instance, functiondrop):
			dude.connect("drop_organ_to_dude", instance, functiondrop)
		if not dude.is_connected("start_chop", instance, functionchop):
			dude.connect("start_chop", instance, functionchop)

func add_belt():
	var new_child = belt.instance()
	new_child.hide_dude()
	self.add_child(new_child)
	new_child.start_moving()
	self.distribute_belts()

func _ready():
	self.get_child(0).hide_dude()
	self.get_child(0).start_moving()
	for i in range(start_belt-1):
		self.add_belt()
	self.distribute_belts()

#func _process(delta):
#	pass
