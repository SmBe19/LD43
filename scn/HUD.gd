extends Node

signal waiting_room_full

export(float) var waitingSpeed = 0.05
export(float) var waitingSpeedAcc = 0.0005
var waiting = 0
var score = 0
var survived = 0
var died = 0
var money = 0

func change_money(amount):
	if money + amount < 0:
		return false
	money += amount
	self.update_money_label()
	return true

func change_score(amount):
	score += amount
	self.update_score_label()

func add_survived():
	survived += 1

func add_died():
	died += 1

func subtract_waiting():
	if waiting >= 1:
		waiting -= 1
		return true
	else:
		return false

func update_score_label():
	$Score.text = str(score)

func update_money_label():
	$Money.text = "$ " + str(money) + "k"

func _ready():
	pass

func _process(delta):
	waiting += delta * waitingSpeed
	waitingSpeed += delta * waitingSpeedAcc
	$Waiting.value = waiting
	if waiting > $Waiting.max_value:
		emit_signal("waiting_room_full")
