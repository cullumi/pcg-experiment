extends Control

export (String) var title = "Hello there!" setget set_title, get_title

func set_title(value:String):
	title = value
	$VBoxContainer/Title.text = title
func get_title(): return title

func _ready():
	set_title(title)
