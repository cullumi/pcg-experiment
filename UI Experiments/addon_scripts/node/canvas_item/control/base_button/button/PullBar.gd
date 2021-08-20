extends Button

class_name PullBar

export (bool) var drag_self = true
export (bool) var lock_x_axis = false
export (bool) var lock_y_axis = false

signal dragged(relative)
signal clicked

enum {X_AXIS, Y_AXIS}

var dragging = false

func _init():
	connect("button_up", self, "_button_up")
	connect("dragged", self, "_dragged")
	keep_pressed_outside = true

func _input(event):
	if pressed:
		if event is InputEventMouseMotion:
			var relative = event.relative
			if relative != Vector2():
				dragging = true
				emit_signal("dragged", relative)

func _button_up():
	if dragging:
		dragging = false
	else:
		emit_signal("clicked")

func _dragged(relative:Vector2):
	if drag_self:
		relative *= Vector2(not lock_x_axis, not lock_y_axis)
		rect_position += relative

func set_axis_lock(axis:int, value:bool):
	match axis:
		X_AXIS: lock_x_axis = value
		Y_AXIS: lock_y_axis = value
