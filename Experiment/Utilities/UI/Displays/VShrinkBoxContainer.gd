extends VBoxContainer

class_name VShrinkBoxContainer

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
#	print("Shrinking VBox...")
	var children = get_children()
	var start_size = rect_size
	var size = 0
	for child in children:
		size += child.rect_size.y
	size += get_constant("separation") * (children.size()-1)
	rect_min_size.y = size
	rect_size.y = size
#	print("Shrank: ", start_size, " --> ", rect_size)
