extends Control

var latest_event

func _input(event):
	pass

func _unhandled_input(event):
	latest_event = event
	#if pressed("select"): unfocus_all()
	if pressed("restart"): restart()
	elif pressed("reinitialize"): reinitialize()
	elif pressed("toggle_db_menu"): toggle_db_menu()

func pressed(action:String):
	return latest_event.is_action_pressed(action)

func restart():
# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()

func reinitialize():
	Database.initialize()
	DatabaseMenu.update_menu()

func toggle_db_menu():
	DatabaseMenu.visible = not DatabaseMenu.visible

func unfocus_all():
	var current_focus_control = get_focus_owner()
	if current_focus_control:
		current_focus_control.release_focus()
