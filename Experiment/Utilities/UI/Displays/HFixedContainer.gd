extends FixedContainer

class_name HFixedContainer

func realign_child(child):
	var pos = Vector2(child.rect_position.x, 0)
	var size = Vector2(child.rect_size.x, rect_size.y)
	fit_child_in_rect(child, Rect2(pos, size))
	rect_min_size.x = get_largest_rect_size_x()

func get_largest_rect_size_x():
	var size = 0
	for child in get_children():
		size = max(size, child.rect_size.x)
	return size
