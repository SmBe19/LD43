extends Node2D

func on_take_organ(dude, organ):
	$ActiveOrgan.set(dude, organ)

func on_drop_organ(dude, organ):
	if organ == $ActiveOrgan.organ:
		$ActiveOrgan.receiver = dude

func _ready():
	$Surgery.visible = false

func _on_BlackMarket_buy_organ(organ):
	$ActiveOrgan.set(null, organ)

func _on_BlackMarket_sell_organ():
	if $ActiveOrgan.organ != -1:
		$BlackMarket.sell_organ($ActiveOrgan.organ)
		$ActiveOrgan.dude = null
		$ActiveOrgan.receiver = null
		$ActiveOrgan.drop()
