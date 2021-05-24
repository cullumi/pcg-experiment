extends Node

func _input(event):
	if event.is_action_pressed("restart"):
		print("Restarting")
# warning-ignore:return_value_discarded
		get_tree().reload_current_scene()
	elif event.is_action_pressed("reinitialize"):
		print("Reinitializing")
		Database.initialize()
		DatabaseMenu.update_menu()
