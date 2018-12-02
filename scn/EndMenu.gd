extends Node

var submitted = false
var username = ""

func submit_highscore(username, score):
	# please don't submit fake scores, would be sad to take down the high score system
	self.username = username
	var magic = score % 17 * len(username) + floor(score / 17)
	$SubmitRequest.request("http://ludumdare.games.smeanox.com/LD43/hs/submit.php?username=" + username + "&score=" + str(score) + "&magic=" + str(magic))
	$NickName.visible = false
	$SubmitButton.visible = false
	submitted = true

func get_highscore():
	$HighscoreRequest.request("http://ludumdare.games.smeanox.com/LD43/hs/get.php")

func _on_btn_red_pressed():
	globals.main_menu()

func _on_btn_green_pressed():
	globals.start_game()

func _ready():
	$FailReason.text = globals.fail_reason
	$NickName.grab_focus()
	self.get_highscore()

func _input(event):
	if not submitted and event.is_action("ui_accept"):
		self._on_SubmitButton_pressed()
		get_tree().set_input_as_handled()

func _on_SubmitButton_pressed():
	self.submit_highscore($NickName.text, globals.score)

func _on_SubmitRequest_request_completed(result, response_code, headers, body):
	self.get_highscore()

func _on_HighscoreRequest_request_completed(result, response_code, headers, body):
	if response_code != 200:
		$HighScore.text = "Could not load highscores..."
	else:
		var high = JSON.parse(body.get_string_from_utf8())
		var textUsers = ""
		var textScore = ""
		for res in high.result:
			textUsers += res.name + "\n"
			textScore += str(res.score) + "\n"
		$HighScoreName.text = textUsers
		$HighScoreScore.text = textScore
