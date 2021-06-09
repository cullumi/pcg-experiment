extends Container

class_name FixedContainer

func _ready():
	var children = get_children()
	for child in children:
		if not child.is_connected("resized", self, "realign_child"):
			child.connect("resized", self, "realign_child", [child])
	connect("resized", self, "realign_children")

func add_child(child:Node, lun:bool=false):
	.add_child(child, lun)
	if child is Control:
		child.connect("resized", self, "realign_child", [child])
	realign_child(child)

func realign_children():
	for child in get_children():
		realign_child(child)

func realign_child(child):
	fit_child_in_rect(child, Rect2(Vector2(), rect_size))
