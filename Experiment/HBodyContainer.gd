extends BodyContainer

class_name HBodyContainer

var last_height:float = 0

func align():
	
	var height:float = rect_size.y
	if height == last_height:
		return
	else:
		last_height = height
	
	var children:Array = get_children()
	var t_width:float = 0
	var sep:Vector2 = Vector2()
	var cl_num:int = 0
	var cl_size:Vector2 = Vector2()
	var cl_count:int = 0
	
	for child in children:
		
		var c_size = child.rect_size
		sep.y = v_separation if cl_count else 0
		if not cl_size.y + sep.y + c_size.y < height:
			t_width += cl_size.x + sep.x
			sep = Vector2()			
			cl_size = Vector2()
			cl_count = 0
			cl_num += 1
		
		cl_size.x = max(cl_size.x, c_size.x)
		sep.x = h_separation if cl_num else 0
		var c_pos = Vector2(t_width, cl_size.y) + sep
		cl_count += 1
		cl_size.y += sep.y + c_size.y
		fit_child_in_rect(child, Rect2(c_pos, c_size))
#		print(t_width)
	
	t_width += cl_size.x + sep.x

	rect_size.x = t_width
