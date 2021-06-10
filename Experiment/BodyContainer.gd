extends Container

class_name BodyContainer

export (float) var h_separation = 5
export (float) var v_separation = 5

func add_child_below_node(node:Node, child:Node, lun:bool=false):
	.add_child_below_node(node, child, lun)
	child_added(child)

func add_child(child:Node, lun:bool=false):
	.add_child(child, lun)
	child_added(child)

func child_added(child:Node):
	if child is Control:
		align()
# warning-ignore:return_value_discarded
		child.connect("resized", self, "align")
# warning-ignore:return_value_discarded
		child.connect("tree_exited", self, "align")

func _draw():
	align()

func align():
	pass
