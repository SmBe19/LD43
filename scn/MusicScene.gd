extends Node

var songs = [
	preload("res://msc/song001.ogg"),
	preload("res://msc/song002.ogg"),
	preload("res://msc/LD43_011.ogg"),
	preload("res://msc/LD43_021.ogg"),
]

var volumes = [
	-8,
	-2,
	4,
	2
]

var plying = 3

func play(force=false):
	var s = plying
	if not force:
		while s == plying:
			s = randi()%len(songs)
	plying = s
	$Song.stream = songs[s]
	$Song.volume_db = volumes[s]
	$Song.play()

func stop():
	$Song.stop()

func _on_Song_finished():
	$NextSongTimer.start()

func _ready():
	randomize()
	play(true)

func _on_NextSongTimer_timeout():
	play()
