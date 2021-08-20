extends MarginContainer

class_name SplitsContainer

var splits:Array = []
var children:Array = []
var moved_child:Node

func _ready():
	for child in .get_children():
		child_added(child, false)
	align(true)

# Functionality

func align(equally_space:bool=false):
	if children.size() > 1:
		align_children(equally_space)
	else:
		if not children.empty():
			var child = children[0]
			if self != child.get_parent():
				reparent_child(child, self)
		trim_splits(0)

func align_children(equally_space:bool=false, size:float=rect_size.x):
	print("\n", "[", self.name, "] ", "Align Children: ", Strings.to_names(children))
	var i = 0
	for child in children:
		print("	Child: ", child.name)
		print("	Splits: ", splits.size(), " (", i, ") ", splits)
		if i >= splits.size():
			add_split()
		print("	Splits: ", splits.size(), " (", i, ") ", splits)
		reparent_child(child, splits[i])
		if equally_space:
			var offset = size / children.size()
			splits[i].split_offset = offset
		i += 1
	trim_splits(i)

func trim_splits(idx):
	print("[", self.name, "] ", "Trim Splits to: ", idx)
	if idx >= splits.size(): return
	var freed_splits = splits.slice(idx, splits.size())
	for split in freed_splits:
		split.name = "DELETED"
		split.queue_free()
	splits.resize(idx)

func add_split(type=HSplitContainer):
	var new_split = type.new()
	if not splits.empty():
		splits.back().add_child(new_split)
	else:
		.add_child(new_split)
	new_split.name = "sub_vs " + String(splits.size())
	splits.append(new_split)

func reparent_child(child, new_parent):
	moved_child = child
#	print("Reparenting... ")
#	print("RP Start: ", Strings.to_names(children))
	if new_parent != child.get_parent():
		if child.get_parent() != null:
			remove_child(child)
		add_to(child, new_parent)
	moved_child = null

func add_to(child, new_parent):
	print("Adding: ", child.name, " to ", new_parent.name)
	if (new_parent != self):
		new_parent.add_child(child)
	else:
		.add_child(child)
	if not children.has(child): children.append(child)

# Updates and Overrides

func _draw():
	align()

func get_child(idx):
	return children[idx]

func get_child_count():
	return children.size()

func get_children():
	return children

func size():
	return children.size()

func add_child_below_node(node:Node, child:Node, lun:bool=false):
	.add_child_below_node(node, child, lun)
	child_added(child)

func add_child(child:Node, lun:bool=false, evenly_spaced:bool=false):
	.add_child(child, lun)
	child_added(child, true, evenly_spaced)

func child_added(child:Node, align:bool=true, evenly_spaced:bool=false):
	if child is Control:
		assert(not children.has(child), "S: " + child.name)
		children.append(child)
		if align: align(evenly_spaced)
		child.connect("tree_exited", self, "child_left_tree", [child])

func remove_child(child:Node):
	var parent = child.get_parent()
	print("Removing: ", child.name, " from ", parent.name)
	assert(children.has(child), "S: Child Not Found")
	children.erase(child)
	if parent != self:
		parent.remove_child(child)
	else:
		.remove_child(child)

func child_left_tree(child:Node, align=true):
	if child != moved_child:
#		print("Removed: ", child.name)
#		print("R Start: ", Strings.to_names(children))
		if children.has(child): children.erase(child)
#		print("R End: ", Strings.to_names(children))
		child.disconnect("tree_exited", self, "child_left_tree")		
		if align:
			align()
