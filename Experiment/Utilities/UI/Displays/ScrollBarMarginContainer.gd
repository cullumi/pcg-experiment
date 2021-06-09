extends MarginContainer

export (Vector2) var base_margins = Vector2(10, 0)

var scroll_size:Vector2

func initialize(new_scroll_size:Vector2):
	scroll_size = new_scroll_size
	v_scroll_toggled(false)
	h_scroll_toggled(false)

func v_scroll_toggled(vsv:bool):
	var margin = base_margins.x + (0 if vsv else scroll_size.x)
	add_constant_override("margin_right", margin)

func h_scroll_toggled(hsv:bool):
	var margin = base_margins.y + (0 if hsv else scroll_size.y)
	add_constant_override("margin_bottom", margin)
