extends GridContainer

class_name ResizableGrid

enum {TOO_BIG=0, IT_FITS=1}

func add_child_below_node(node:Node, child:Node, lun:bool=false):
	.add_child_below_node(node, child, lun)
	added_child(child)

func add_child(child:Node, lun:bool=false):
	.add_child(child, lun)
	added_child(child)

func added_child(child:Node):
	if child is Control:
		realign()
		child.connect("resized", self, "realign")
		child.connect("tree_exited", self, "realign")

func realign():
	var start_rect = rect_size
	var max_width = rect_size.x
	var children = get_children()
	var largest_row_width = largest_row_size(children)
	if largest_row_width > max_width:
		while largest_row_width > max_width and columns > 1:
			columns -= 1
			largest_row_width = largest_row_size(children)
	elif largest_row_width < max_width:
		while largest_row_width < max_width and children.size() > columns:
			largest_row_width = largest_row_size(children, columns+1)
			if largest_row_width < max_width:
				columns += 1
	rect_size.y = calc_column_height(children)
#	print("Grid Rect: ", start_rect, " --> ", rect_size, " (", largest_row_width, ")")

func calc_column_height(children:Array, column_num=columns):
	var size = 0
	var rows = ceil(children.size()/column_num)
	for r in range(0, rows):
		size += children[r*column_num].rect_size.y
	size += get_constant("hseparation") * (rows-1)
	return size

func largest_row_size(children:Array, column_num=columns):
	var largest:Array = largest_row(children, column_num)
	var size = 0
	for child in largest:
		size += child.rect_size.x
	size += get_constant("vseparation") * (largest.size()-1)
	return size

func largest_row(children:Array, row_size:int):
	var current = []
	var l_childs
	var l_size = 0
	var r = 0
	var size = 0
	for child in children:
		r = (r+1) % row_size
		size += child.rect_size.x
		current.append(child)
		if r == 0:
			if l_size <= size:
				l_size = size
				l_childs = current
			current = []
	if l_childs == null:
		l_childs = current
	return l_childs
