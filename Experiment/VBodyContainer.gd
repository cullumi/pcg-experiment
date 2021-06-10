extends BodyContainer

class_name VBodyContainer

var last_width:float = 0

func align():
	
	var width:float = rect_size.x
	if width == last_width:
		return
	
	var children:Array = get_children()
	var t_height:float = 0
	var sep:Vector2 = Vector2()
	var r_num:int = 0
	var r_size:Vector2 = Vector2()
	var r_count:int = 0
	
	for child in children:
		
		var c_size = child.rect_size
		sep.x = h_separation if r_count else 0
		if not r_size.x + sep.x + c_size.x < width:
			t_height += r_size.y + sep.y
			sep = Vector2()			
			r_size = Vector2()
			r_count = 0
			r_num += 1
		
		r_size.y = max(r_size.y, c_size.y)
		sep.y = v_separation if r_num else 0
		var c_pos = Vector2(r_size.x, t_height) + sep
		r_count += 1
		r_size.x += sep.x + c_size.x
		fit_child_in_rect(child, Rect2(c_pos, c_size))
#		print(t_height)
	
	t_height += r_size.y + sep.y

	rect_size.y = t_height
