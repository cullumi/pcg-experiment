extends Container

class_name VSplitGrid

export (float) var h_separation = 5
export (float) var v_separation = 5

var columns:int
var split_grid:Array
var children:Array

# Functionality

func align():
	pass

func align_columns():
	var new_columns:int = 1
	for column in split_grid:
		if column[0] == 0:
			pass

# Updates and Overrides

func get_children():
	return children

func add_child_below_node(node:Node, child:Node, lun:bool=false):
	.add_child_below_node(node, child, lun)
	child_added(child)

func add_child(child:Node, lun:bool=false):
	.add_child(child, lun)
	child_added(child)

func child_added(child:Node):
	if child is Control:
		children.append(child)
		align()
# warning-ignore:return_value_discarded
		child.connect("resized", self, "align")
# warning-ignore:return_value_discarded
		child.connect("tree_exited", self, "child_removed", [child])

func child_removed(child:Node):
	if child is Control:
		children.erase(child)
		align()

func _draw():
	align()
