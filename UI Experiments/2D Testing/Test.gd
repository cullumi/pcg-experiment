extends Node


func _ready():
	set_process_unhandled_input(true)
	pass # Replace with function body.

func _unhandled_input(event):
	if Input.is_action_just_pressed("mouse_click"):
		print("Clicked!")
