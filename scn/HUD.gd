extends Node

signal waiting_room_full

export(float) var waitingSpeed = 0.1
var waiting = 0
var survived = 0
var died = 0
var money = 0

func change_money(amount):
	if money + amount < 0:
		return false
	money += amount
	self.update_money_label()
	return true

func add_survived():
	survived += 1
	self.update_survived_label()

func add_died():
	died += 1
	self.update_survived_label()

func subtract_waiting():
	if waiting >= 1:
		waiting -= 1
		return true
	else:
		return false

func update_survived_label():
	$Survived.text = survived + "/" + (survived + died)

func update_money_label():
	$Money.text = "$ " + money

func _ready():
	pass

func _process(delta):
	waiting += delta * waitingSpeed
	$Waiting.value = waiting
	if waiting > $Waiting.max_value:
		emit_signal("waiting_room_full")
