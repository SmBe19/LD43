extends Node

export(float) var waitingSpeed = 0.05
export(float) var waitingSpeedAcc = 0.0005
var waiting = 0

const val_change = preload("res://scn/ValueChange.tscn")

func change_money(amount):
	if globals.money + amount < 0:
		return false
	globals.money += amount
	self.update_money_label()
	var change = val_change.instance()
	change.text = ("+ " if amount >= 0 else "- ") + "$ " + str(abs(amount)) + "k"
	change.rect_position.x = $Money.rect_position.x + $Money.rect_size.x / 2
	add_child(change)
	return true

func change_score(amount):
	globals.score += amount
	var change = val_change.instance()
	change.text = ("+ " if amount >= 0 else "- ") + str(abs(amount))
	change.rect_position.x = $Score.rect_position.x
	add_child(change)
	self.update_score_label()
	if globals.score < 0:
		globals.end_menu("Fired for low esteem.")

func subtract_waiting(force=false):
	if waiting >= 1:
		waiting -= 1
		return true
	else:
		if force:
			waiting = 0
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
	$WaitingDudes.text = str(floor(waiting)) + "/" + str($Waiting.max_value-1)
	if waiting > $Waiting.max_value:
		globals.end_menu("You worked too slowly.")

func _on_MuteButton_toggled(button_pressed):
	if button_pressed:
		MusicScene.get_node("Song").stop()
	else:
		MusicScene.get_node("Song").play()
