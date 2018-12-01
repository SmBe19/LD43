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

func rand_bool(prob):
	return randf() < prob

func randomize_organs():
	organs[globals.ORGANS.BRAIN] = rand_bool(0.8)
	organs[globals.ORGANS.HEART] = rand_bool(0.8)
	organs[globals.ORGANS.LUNGS] = rand_bool(0.5)
	organs[globals.ORGANS.LIVER] = rand_bool(0.5)
	organs[globals.ORGANS.LKIDNEY] = rand_bool(0.2)
	organs[globals.ORGANS.RKIDNEY] = rand_bool(0.2)
	self.apply_organs()

func copy_organs(dude):
	organs = dude.organs
	self.apply_organs()

func receive_organ(organ):
	if not organs[organ]:
		organs[organ] = true
		self.apply_organs()

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

func on_drop_organ(organ):
	if $"..".moving:
		return
	if not organs[organ]:
		emit_signal("drop_organ_to_dude", self, organ)
