extends FixedContainer

class_name VFixedContainer

func realign_child(child):
	var pos = Vector2(0, child.rect_position.y)
	var size = Vector2(rect_size.x, child.rect_size.y)
	fit_child_in_rect(child, Rect2(pos, size))
	rect_min_size.y = get_largest_rect_size_y()

func get_largest_rect_size_y():
	var size = 0
	for child in get_children():
		size = max(size, child.rect_size.y)
	return size
