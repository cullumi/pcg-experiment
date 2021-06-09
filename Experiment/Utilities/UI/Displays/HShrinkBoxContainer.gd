extends HBoxContainer

class_name HShrinkBoxContainer

func _ready():
	var children = get_children()
	for child in children:
		if not child.is_connected("resized", self, "shrink"):
			child.connect("resized", self, "shrink")
	shrink()

func add_child(child:Node, lun:bool=false):
	.add_child(child, lun)
	if child is Control:
# warning-ignore:return_value_discarded
		child.connect("resized", self, "shrink")
	shrink()

func shrink():
#	print("Shrinking HBox...")
	var start_size = rect_size
	var children = get_children()
	var size = 0
	for child in children:
		size += child.rect_size.x
	size += get_constant("separation") * (children.size()-1)
	rect_min_size.x = size
	rect_size.x = size
#	print("Shrank: ", start_size, " --> ", rect_size)
