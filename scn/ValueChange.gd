extends Control

var text setget text_set, text_get

func text_set(val):
	$Text.text = val

func text_get():
	return $Text.text

func _ready():
	$Animation.play("Hide")

func finished():
	$"..".remove_child(self)