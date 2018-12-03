extends Node

const quotes = [
	"Hi there!",
	"Nice to meet you!",
	"green button to start",
	"Surgeon Dr Dr Ludwig",
	"Ludum Dare 43",
	"sacrifices must be made",
]

func _on_btn_red_pressed():
	globals.exit_game()

func _on_btn_green_pressed():
	globals.start_game()

func _on_scalpel_pressed():
	globals.start_game(true)

func random_text():
	$FailReason.text = quotes[randi()%len(quotes)]

func _ready():
	randomize()
	self.random_text()

func _on_Timer_timeout():
	self.random_text()
