extends Node2D

var active_chop = null

func on_take_organ(dude, organ):
	$ActiveOrgan.set(dude, organ)

func on_drop_organ(dude, organ):
	if organ == $ActiveOrgan.organ:
		$ActiveOrgan.receiver = dude

func on_start_chop(dude):
	active_chop = dude
	$ChopChop.start_chop()

func _ready():
	$Surgery.visible = false
	$ChopChop.visible = false

func _on_BlackMarket_buy_organ(organ):
	$ActiveOrgan.set(null, organ)

func _on_BlackMarket_sell_organ():
	if $ActiveOrgan.organ != -1 and $ActiveOrgan.dude != null:
		$BlackMarket.sell_organ($ActiveOrgan.organ)
		$ActiveOrgan.dude = null
		$ActiveOrgan.receiver = null
		$ActiveOrgan.drop()

func _on_ChopChop_chop_failed():
	if active_chop != null:
		active_chop.chop_fail()
	active_chop = null

func _on_ChopChop_chop_finished():
	if active_chop != null:
		active_chop.chop()
	active_chop = null
