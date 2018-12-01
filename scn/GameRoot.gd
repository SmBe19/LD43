extends Node2D

func on_take_organ(dude, organ):
	$ActiveOrgan.set(dude, organ)

func on_drop_organ(dude, organ):
	if organ == $ActiveOrgan.organ:
		$ActiveOrgan.receiver = dude

func _ready():
	$Surgery.visible = false
