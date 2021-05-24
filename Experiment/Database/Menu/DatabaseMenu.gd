extends Control

onready var options:OptionsPanel = $VBoxContainer/option_panel
onready var display:DisplayPanel = $VBoxContainer/display_panel

func _ready():
	options.initialize()

func update_menu():
	display.update_display()

func get_reqs():
	return options.reqs
