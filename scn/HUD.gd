extends Node

export(float) var waitingSpeed = 0.05
export(float) var waitingSpeedAcc = 0.0005
var waiting = 0

func change_money(amount):
	if globals.money + amount < 0:
		return false
	globals.money += amount
	self.update_money_label()
	return true

func change_score(amount):
	globals.score += amount
	self.update_score_label()
	if globals.score < 0:
		globals.end_menu("fired for low esteem")

func subtract_waiting():
	if waiting >= 1:
		waiting -= 1
		return true
	else:
		return false

func update_score_label():
	$Score.text = str(globals.score)

func update_money_label():
	$Money.text = "$ " + str(globals.money) + "k"

func _ready():
	update_money_label()
	update_score_label()

func _process(delta):
	waiting += delta * waitingSpeed
	waitingSpeed += delta * waitingSpeedAcc
	$Waiting.value = waiting
	if waiting > $Waiting.max_value:
		globals.end_menu("you worked too slow")
