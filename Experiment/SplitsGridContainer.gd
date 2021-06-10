extends MarginContainer

class_name SplitsGridContainer

var readied:bool = false
var columns:int = 1
var h_split:HSplitsContainer
var children:Array = []
var moved_child:Node

# Initalization

func _init():
	h_split = HSplitsContainer.new()
	h_split.name = "HSplits"
	.add_child(h_split)

func _ready():
	for child in .get_children():
		if child != h_split:
			child_added(child, false)
#	print("Children: ", children)
	align(true)
	readied = true

func _draw():
	if readied:
		align()

# Functionality

func align(evenly_space:bool=false):
	print("Aligning: ", Strings.to_names(children))
	if children.size() > 1:
		align_children(evenly_space)
	else:
		if not children.empty():
			var child = children[0]
			var v_split = get_split(0, evenly_space)
			reparent_child(child, v_split)
		h_split.trim_splits(0)
	print("VSplits:")
	for child in h_split.get_children():
		print("   ", child.name, ": ", Strings.to_names(child.get_children()))

func align_children(evenly_space:bool=false):
	var v_split
	var v_idx:int = 0
	var i = 0
#	print("Rate: ", children.size()/columns, " (", columns, ")")
	for child in children:
		var ti = i
		i = i % int(ceil(children.size()/columns))
#		print("i: ", ti, " -> ", i)
		if i == 0:
#			print("Split...")
			v_split = get_split(v_idx, evenly_space)
			v_idx += 1
		reparent_child(child, v_split)
		i += 1

func get_split(idx:int, evenly_space:bool=false, type=VSplitsContainer):
	var v_split
	if idx >= h_split.size():
		v_split = type.new()
		v_split.name = "vsplit " + String(idx)
		h_split.add_child(v_split, false, evenly_space)
		print("new v_split: ", v_split.name, " / ", Strings.to_names(h_split.get_children()))
	else:
		v_split = h_split.get_child(idx)
		print("old v_split: ", v_split.name, " / ", Strings.to_names(h_split.get_children()))
	return v_split

func reparent_child(child, new_parent, evenly_space=false):
	moved_child = child
	var old_parent = child.get_parent()
	if new_parent != old_parent:
		if old_parent != null:
			print("G: Reparent Child: ", new_parent.name, " vs ", old_parent.name)
			print(old_parent)
			old_parent.remove_child(child)
		else:
			print("G: Reparent Child: ", new_parent.name, " vs ", old_parent)
		add_to(child, new_parent, evenly_space)
	moved_child = null

func add_to(child, new_parent, evenly_space):
	print("Adding: ", child.name, " to ", new_parent.name)
	new_parent.add_child(child, evenly_space)
	if not children.has(child): children.append(child)

# Updates and Overrides

func get_child(idx):
	return children[idx]

func get_child_count():
	return children.size()

func get_children():
	return children

func add_child_below_node(node:Node, child:Node, lun:bool=false):
	.add_child_below_node(node, child, lun)
	child_added(child)

func add_child(child:Node, lun:bool=false):
	.add_child(child, lun)
	child_added(child)

func child_added(child:Node, align:bool=true):
	if child is Control:
		assert(not children.has(child), "G: " + child.name)
		children.append(child)
		if align: align()
		child.connect("tree_exited", self, "child_left_tree", [child])

func remove_child(child:Node):
	var parent = child.get_parent()
	print("Removing: ", child.name, " from ", parent.name)
	assert(children.has(child), "G: Child Not Found")
	children.erase(child)
	if parent != self:
		parent.remove_child(child)
	else:
		.remove_child(child)

func child_left_tree(child:Node):
	if child != moved_child:
#		print("Removed: ", child.name)
#		if children.has(child): children.erase(child)
#		child.disconnect("tree_exited", self, "child_removed")		
		align()
