extends Node2D

signal take_organ_from_dude(dude, organ)
signal drop_organ_to_dude(dude, organ)

var brain = true
var heart = true
var lungs = true
var liver = true
var lkidney = true
var rkidney = true
var organs = {}
var orig_organs = {}

func debug(txt):
	print(txt)
	print("organs: ", organs)
	print("orig: ", orig_organs)

func rand_bool(prob):
	return randf() < prob

func randomize_organs():
	organs[globals.ORGANS.BRAIN] = rand_bool(0.8)
	organs[globals.ORGANS.HEART] = rand_bool(0.8)
	organs[globals.ORGANS.LUNGS] = rand_bool(0.5)
	organs[globals.ORGANS.LIVER] = rand_bool(0.5)
	organs[globals.ORGANS.LKIDNEY] = rand_bool(0.5)
	organs[globals.ORGANS.RKIDNEY] = rand_bool(0.5)
	for k in organs:
		orig_organs[k] = organs[k]
	self.apply_organs()

func copy_organs(dude):
	for k in organs:
		organs[k] = dude.organs[k]
	for k in organs:
		orig_organs[k] = organs[k]
	self.apply_organs()

func receive_organ(organ):
	if not organs[organ]:
		organs[organ] = true
		self.apply_organs()
	debug("receive_organ")

func get_score():
	debug("score")
	var score = 0
	for i in range(6):
		if not organs[i]:
			if not((i == 4 or i == 5) and (organs[4] or organs[5])):
				print("missing ", i)
				return -7
		if organs[i] and not orig_organs[i]:
			score += 2
	return score

func apply_organs():
	$brain.present = organs[globals.ORGANS.BRAIN]
	$heart.present = organs[globals.ORGANS.HEART]
	$lungs.present = organs[globals.ORGANS.LUNGS]
	$liver.present = organs[globals.ORGANS.LIVER]
	$lkidney.present = organs[globals.ORGANS.LKIDNEY]
	$rkidney.present = organs[globals.ORGANS.RKIDNEY]

func on_take_organ(organ):
	if $"..".moving:
		return
	if organs[organ]:
		organs[organ] = false
		self.apply_organs()
		emit_signal("take_organ_from_dude", self, organ)
	debug("on_take_organ")

func on_drop_organ(organ):
	if $"..".moving:
		return
	if not organs[organ]:
		emit_signal("drop_organ_to_dude", self, organ)
