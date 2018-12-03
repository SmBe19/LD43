extends Node

var submitted = false
var username = ""

func submit_highscore(username, score):
	if submitted:
		return
	# please don't submit fake scores, would be sad to take down the high score system
	self.username = username
	var magic = score % 17 * len(username) + floor(score / 17)
	$SubmitRequest.request("http://ludumdare.games.smeanox.com/LD43/hs/submit.php?username=" + username + "&score=" + str(score) + "&magic=" + str(magic))
	$NickName.visible = false
	$SubmitButton.visible = false
	submitted = true
	print("submit ", username, ": ", score)

func get_highscore():
	$HighscoreRequest.request("http://ludumdare.games.smeanox.com/LD43/hs/get.php")

func _on_btn_red_pressed():
	globals.main_menu()

func _on_btn_green_pressed():
	globals.start_game()

func _ready():
	$FailReason.text = globals.fail_reason
	$NickName.grab_focus()
	$HighScoreName.text = "Loading highscore...\n\nYour score: " + str(globals.max_score)
	self.get_highscore()

func _input(event):
	if not submitted and event.is_action("ui_accept"):
		self._on_SubmitButton_pressed()
		get_tree().set_input_as_handled()

func _on_SubmitButton_pressed():
	self.submit_highscore($NickName.text, globals.max_score)

func _on_SubmitRequest_request_completed(result, response_code, headers, body):
	if response_code == 200:
		self.get_highscore()
	else:
		submitted = false
		$NickName.visible = true
		$SubmitButton.visible = true

func _on_HighscoreRequest_request_completed(result, response_code, headers, body):
	if response_code != 200:
		$HighScoreName.text = "Could not load highscores...\n\nYour score: " + str(globals.max_score)
	else:
		var username = $NickName.text
		if len(username) == 0:
			username = "You"
		var username_arr = "-> " + username + " <-"
		var score = globals.max_score
		var high = JSON.parse(body.get_string_from_utf8())
		var textUsers = ""
		var textScore = ""
		var found = false
		var ress = high.result
		while len(ress) > 8:
			ress.pop_back()
		for res in ress:
			if not found and res.score <= score:
				textUsers += username_arr + "\n"
				textScore += str(score) + "\n"
				found = true
			if res.name == username and int(res.score) == score:
				continue
			textUsers += res.name + "\n"
			textScore += str(res.score) + "\n"
		if not found:
			textUsers += username + "\n"
			textScore += str(score) + "\n"
		$HighScoreName.text = textUsers
		$HighScoreScore.text = textScore
