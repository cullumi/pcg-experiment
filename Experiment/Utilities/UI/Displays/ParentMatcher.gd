extends Control

class_name ParentMatcher

func _ready():
	var parent = get_parent()
	if parent is Control:
		parent.connect("resized", self, "realign")

func realign():
	var parent = get_parent()
	rect_size = parent.rect_size
	rect_position = parent.rect_position
