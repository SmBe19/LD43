extends Node2D

signal take_organ_from_dude(dude, organ)
signal drop_organ_to_dude(dude, organ)
signal start_chop(dude)

var organs = {}
var orig_organs = {}
var alive = false
var chopped = false
var add_ons = [false, false, false, false]
var alive_since = 0
const base_lifetime = 60
const lifetimes = [60, 50, 50, 20, 20, 20]
var max_lifetime = 100

onready var organ_objs = [$brain, $heart, $lungs, $liver, $lkidney, $rkidney]

func _ready():
	max_lifetime = base_lifetime
	for i in range(6):
		max_lifetime += lifetimes[i]
	$LifeBar.max_value = max_lifetime

func rand_bool(prob):
	return randf() < prob

func randomize_organs():
	organs[globals.ORGANS.BRAIN] = rand_bool(0.8)
	organs[globals.ORGANS.HEART] = rand_bool(0.8)
	organs[globals.ORGANS.LUNGS] = rand_bool(0.5)
	organs[globals.ORGANS.LIVER] = rand_bool(0.4)
	organs[globals.ORGANS.LKIDNEY] = rand_bool(0.2)
	organs[globals.ORGANS.RKIDNEY] = rand_bool(0.2)
	for k in organs:
		orig_organs[k] = organs[k]
	add_ons = [rand_bool(0.1), rand_bool(0.05), rand_bool(0.05), rand_bool(0.05)]
	alive_since = 0
	alive = true
	chopped = false
	self.apply_organs()
	self.apply_addons()

func copy_organs(dude):
	for k in organs:
		organs[k] = dude.organs[k]
	for k in organs:
		orig_organs[k] = organs[k]
	for i in range(len(add_ons)):
		add_ons[i] = dude.add_ons[i]
	alive_since = dude.alive_since
	alive = dude.alive
	chopped = dude.chopped
	self.apply_organs()
	self.apply_addons()

func receive_organ(organ):
	if not alive:
		return
	if not organs[organ]:
		organs[organ] = true
		self.apply_organs()

func get_missing():
	var missing = []
	for i in range(5):
		if not organs[i]:
			if i == 4 and organs[5]:
				continue
			missing.append(i)
	return missing

func get_score():
	if not alive:
		return -11
	var score = 3
	var missing = len(self.get_missing())
	for i in range(6):
		if organs[i] and not orig_organs[i]:
			score += 2
	if missing > 0:
		return -missing - 3
	return score

func get_feedback_text():
	if not alive:
		return "Hey, this one is dead!"
	var score = self.get_score()
	if score == -8:
		return "Hey, this one is empty!"
	if score < 0:
		return "Hey, you forgot the " + self.get_missing_organs() + "!"
	return "Thanks, as good as new!"

func get_missing_organs():
	var missing = self.get_missing()
	if len(missing) == 0:
		return "nothing"
	var txt = globals.ORGAN_NAMES[missing[0]]
	for i in range(1, len(missing) - 1):
		txt += ", " + globals.ORGAN_NAMES[missing[i]]
	if len(missing) > 1:
		txt += " and " + globals.ORGAN_NAMES[missing[-1]]
	return txt

func chop():
	chopped = true
	self.apply_organs()

func chop_fail():
	chopped = true
	die()

func get_lifetime():
	var lifetime = base_lifetime
	for i in range(6):
		if organs[i]:
			lifetime += lifetimes[i]
	return lifetime

func die():
	alive = false
	alive_since = max_lifetime
	$LifeBar.value = 0
	self.apply_organs()

func _process(delta):
	if not alive:
		return
	alive_since += delta * globals.death_speed
	if alive_since > self.get_lifetime():
		die()
	$LifeBar.value = self.get_lifetime() - alive_since

func apply_organs():
	$brain.present = organs[globals.ORGANS.BRAIN]
	$heart.present = organs[globals.ORGANS.HEART]
	$lungs.present = organs[globals.ORGANS.LUNGS]
	$liver.present = organs[globals.ORGANS.LIVER]
	$lkidney.present = organs[globals.ORGANS.LKIDNEY]
	$rkidney.present = organs[globals.ORGANS.RKIDNEY]
	
	for child in organ_objs:
		child.alive = alive
		child.visible = chopped
	
	$ChopButton.visible = not chopped

func apply_addons():
	$clothes.visible = add_ons[0]
	$sunglasses.visible = add_ons[1]
	$eyes.visible = add_ons[2]
	$bandana.visible = add_ons[3]

func on_take_organ(organ):
	if $"..".moving:
		return
	if alive and organs[organ]:
		organs[organ] = false
		self.apply_organs()
		emit_signal("take_organ_from_dude", self, organ)

func on_drop_organ(organ):
	if $"..".moving:
		return
	if alive and not organs[organ]:
		emit_signal("drop_organ_to_dude", self, organ)

func _on_ChopButton_pressed():
	emit_signal("start_chop", self)
