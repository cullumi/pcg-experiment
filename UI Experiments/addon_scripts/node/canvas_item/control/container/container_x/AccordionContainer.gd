extends ContainerX

class_name AccordionContainer

# Properties
export (bool) var match_content_depth setget set_mcd, get_mcd
export (bool) var invert = false setget set_invert, get_invert
export (bool) var lock = false setget set_lock, get_lock
export (bool) var lock_to_max_length = false setget set_ltml, get_ltml
export (bool) var use_custom_lock_length = false setget set_ucll, get_ucll
export (float) var custom_lock_length = 100 setget set_cll, get_cll
export (float) var pull_bar_thickness = 20 setget set_pbt, get_pbt
export (float) var spacing = 5 setget set_spacing, get_spacing
export (int) var size = 0 setget set_num, get_num
export (bool) var debug = false

# Contents
var pull_bars:Array = []
var contents:Array = []
var content_views:Array = []

# Alignment
var strict_axis:int = X_AXIS
var free_axis:int = Y_AXIS
var contents_inverted:bool = false
var lock_length:float

# Initialization

func _init():
	update_lock_length()
	initialize_axis()

func initialize_axis():
	strict_axis = X_AXIS
	free_axis = Y_AXIS

func _enter_tree():
	for child in get_children():
		if child is Control:
			if child == backpanel: continue
			if contents.has(child): continue
			if content_views.has(child): continue
			insert(child, false)
	align()


# Insertion and Removal

func insert(content:Control, realign:bool=true, index:int=size):
	add_content_view(content)
	content.rect_position = Vector2()
	contents.insert(index, content)
	size += 1
	if size > 0:
		add_pull_bar()
	if realign: align()

func remove(content:Control, realign:bool=true):
	var idx = contents.find(content)
	var content_view:ContentView = content_views[idx]
	if content_view:
		if content_view.get_children().has(content):
			content_view.remove_child(content)
		.remove_child(content_view)
		content_view.queue_free()
	var pull_bar:PullBar = pull_bars[idx]
	if pull_bar:
		.remove_child(pull_bar)
		pull_bar.queue_free()
	size -= 1
	if realign: align()


# Signals

func _resized():
	align()

func _pull_bar_dragged(relative:Vector2, index:int):
	cascade(relative[free_axis], index)

func _pull_bar_clicked(index:int):
	toggle_view(index)

func _child_removed(child:Node):
	if contents.has(child):
		remove(child)


# Alignment Debugging

func reset_align_debug_data(p):
	ps.clear()
	pbs.clear()
	cvs.clear()
	pbps.clear()
	cvps.clear()
	ps.append(p)

func update_align_parameters(i):
	dbi = i
	dbcv = "cv"+String(dbi)+" - "+self.name
	dbpb = "pb"+String(dbi)+" - "+self.name
	prints("\ndb/pb: ", dbcv, "/", dbpb)

func print_align_results():
	var total = 0
	for pb in pbs:
		total += pb
	for cv in cvs:
		total += cv
	prints("\nPbs:", pbs)
	prints("Cvs:", cvs)
	prints("Pbps:", pbps)
	prints("Cvps:", cvps)
	prints("Ps:", ps)
	prints("Total:", total)
	prints("Change:", ps.back() - ps.front())

var ps:Array = []
var pbs:Array = []
var cvs:Array = []
var pbps:Array = []
var cvps:Array = []
var dbi = null
var dbcv = null
var dbpb = null


# Alignment

# Notes about Align:
# - Align only modifies the rect_size of Content Views when locked
#	to properly fit contents into the locked length.
# - Align should be called anytime an anlignment-related property is changed.
# - Align uses conditional invert functions that account for the differences
# 	between an inverted and non-inverted layout (such as inverting signs).
func align():
	if (size == 0): return
	update_inversion()
	update_rect_depth()
	update_rect_min()
	update_rect_max()
	
	var total_space = length_lock()
	var position = 0
#	if debug: reset_align_debug_data(position)
	for i in range(0, size):
#		if debug: update_align_parameters(i)
		position += align_content_view(content_views[i], position, dbcv)
		position += align_pull_bar(pull_bars[i], position, dbpb)
#		if debug: ps.append(position)
#	if debug: print_align_results()
	
	var start_pos = invert_offset()
	var length = cur_total_length() * invert_sign()
	stretch_axis(self, free_axis, start_pos, length, 0, "All" if debug else null)
	set_free_size(total_space)
	apply_content_flags()

func align_pull_bar(pull_bar:PullBar, start_pos:float, db=null) -> float:
	if not pull_bar.visible: return 0.0
	var position = start_pos + spacing
	var length = pull_bar_thickness
#	if debug: prints("\nAPB:", start_pos+spacing, "+", pull_bar_thickness*invert_sign(), "(" + db + ")")
	stretch_axis(pull_bar, free_axis, position, length, 0, db)
	if debug:
		pbs.append(pb_space() * invert_sign())
		pbps.append(get_free_position_on(pull_bar))
	return pb_space()

func align_content_view(content_view:ContentView, start_pos:float, db=null) -> float:
	var position = start_pos
	var length = get_free_size_on(content_view)
#	if debug: prints("\nACV:", start_pos, "+", length, "(" + db + ")")
	stretch_axis(content_view, free_axis, position, length, 0, db)
	if debug:
		cvs.append(length * invert_sign())
		cvps.append(get_free_position_on(content_view))
	return length


# Alignment Helpers

func length_lock(length:float=get_lock_length()):
	if not lock:
		pull_bars.back().visible = true
	else:
		pull_bars.back().visible = false
		stretch_all_to_length(length)
	return cur_total_length()

func update_lock_length():
	lock_length = rect_size[free_axis]

func apply_content_flags():
	for pull_bar in pull_bars:
		set_strict_filled_on(pull_bar)
	for content_view in content_views:
		set_strict_filled_on(content_view)
	for content in contents:
		if get_strict_size_flag(content) <= SIZE_EXPAND_FILL:
			set_strict_filled_on(content)

func update_inversion():
	if invert:
		set_free_scale(-1)
		for content in contents:
			set_free_scale_on(content, -1)
			set_free_pivot_on(content, get_free_size_on(content)/2)
			set_free_position_on(content, 0)
		if not contents_inverted:
			contents_inverted = true
			contents.invert()
	else:
		set_free_scale(1)
		for content in contents:
			set_free_scale_on(content, 1)
			set_free_pivot_on(content, 0)
			set_free_position_on(content, 0)
		if contents_inverted:
			contents_inverted = false
			contents.invert()

func update_rect_depth():
	var depth = 0
	if match_content_depth:
		for content in contents:
			depth = get_strict_size_on(content)
	else:
		depth = get_strict_extent_size()
	set_strict_size(depth)

func update_rect_max():
	rect_max_size = Vector2()
	set_strict_max_size(NOMAX)
	for content in contents:
		add_to_free_max_size(get_free_size_on(content))
	add_to_free_max_size(pb_space() * locked_pull_bar_count())

func update_rect_min():
	rect_min_size = Vector2()
	for content in contents:
		set_strict_min_size(max(get_strict_min_size(), get_strict_min_size_on(content)))
	set_free_min_size(pb_space() * locked_pull_bar_count())


# Accordion Actions

func cascade(amount:float, index:int):
	if amount == 0: return
	slide(amount, index)
	align()

func toggle_view(index:int):
	var content_view:ContentView = content_views[index]
	var start_length:float = get_free_size_on(content_view)
	var max_length:float = get_free_max_size_on(content_view)
	var min_length:float = get_free_min_size_on(content_view)
	if start_length <= (max_length-min_length) / 2:
		slide_to_length(start_length, max_length, index)
	else:
		slide_to_length(start_length, min_length, index)
	align()

func stretch_all_to_length(length:float):
	slide_to_length(cur_total_length(), length, size-1)

func slide_to_length(start_length:float, target_length:float, index:int=size-1):
	var start = start_length
	var target = target_length
	
	var rem = invert_sign()
	if start < target:
		rem *= target - start
	elif start > target:
		rem *= -(start - target)
	slide(rem, index)


# Accordion Sliding

func slide(amount:float, index:int):
	amount *= invert_sign()
	if (amount > 0):
		slide_out(amount, index)
	elif (amount < 0):
		slide_in(amount, index)

func slide_out(amount:float, index:int):
	var overpull:float
	var overpush:float
	var subi:int
	
	overpull = pull(abs(amount), index)
	subi = index - 1
	while overpull > 0 and subi >= 0:
		overpull = pull(overpull, subi)
		subi -= 1
	overpush = push(abs(amount-overpull), index + 1)
	return overpush

func slide_in(amount:float, index:int):
	var overpull:float
	var overpush:float
	var subi:int
	
	overpush = push(abs(amount), index)
	subi = index - 1
	while overpush > 0 and subi >= 0:
		overpush = push(overpush, subi)
		subi -= 1
	overpull = pull(abs(amount), index + 1)
	
	return overpull

func push(amount:float, index:int):
	if index < 0 or index >= size: return 0
	var cv = content_views[index]
	
	var result = get_free_size_on(cv) - amount
	var dif = get_free_min_size_on(cv) - result
	var overpush = dif * (0 if dif < 0 else 1)
	set_free_size_on(cv, result-overpush)
	
	return overpush

func pull(amount:float, index:int):
	if index < 0 or index >= size: return 0
	var cv = content_views[index]
	
	var result = get_free_size_on(cv) + amount
	var dif = result - get_free_max_size_on(cv)
	var overpull = dif * (0 if dif < 0 else 1)
	set_free_size_on(cv, result-overpull)
	
	return overpull


# Insertion Helpers

func add_content_view(content:Control):
	var content_view:ContentView = ContentView.new()
	content_view.use_backpanel = use_backpanel
	content_view.set_axis_ignore_max(strict_axis, true)
	content_view.name = "CV " + String(size)
	.add_child(content_view)
	content_views.append(content_view)
	.remove_child(content)
	content_view.add_child(content)
	content_view.connect("child_removed", self, "_child_removed")

func add_pull_bar():
	var pull_bar = PullBar.new()
	pull_bar.drag_self = false
	pull_bar.set_axis_lock(strict_axis, true)
	pull_bar.name = "PB " + String(size-1) + "->" + String(size)
	.add_child_below_node(content_views[size-1], pull_bar)
	pull_bars.append(pull_bar)
	pull_bar.connect("clicked", self, "_pull_bar_clicked", [size-1])
	pull_bar.connect("dragged", self, "_pull_bar_dragged", [size-1])


# Tree Node Overrides

func remove_child(child:Node):
	if (contents.has(child)):
		remove(child)
	else:
		.remove_child(child)

func add_child(child:Node, legible_unique_name:bool=false):
	.add_child(child, legible_unique_name)
	if child is Control: insert(child)

func add_child_below_node(node:Node, child:Node, legible_unique_name:bool=false):
	.add_child_below_node(node, child, legible_unique_name)
	if child is Control:
		if node is Control and contents.has(node):
			insert(child, true, contents.find(node)+1)
		else:
			insert(child)


# Conditional and Value Helpers

# Locking
func get_lock_length() -> float:
	return rect_max_size[free_axis] if lock_to_max_length else (
		custom_lock_length if use_custom_lock_length else extents.size[free_axis])
func locked_pull_bar_count(): return size-1 if lock else size

# Extents
func get_strict_extent_size(): return extents.size[strict_axis]
func get_free_upper_extent(): return extents.position[free_axis] + extents.size[free_axis]
func get_free_lower_extent(): return extents.position[free_axis]

# Inversion
func invert_sign(): return -1 if invert else 1
func invert_offset(): return inverted_offset() if invert else normal_offset()
func inverted_offset(): return get_free_upper_extent()
func normal_offset(): return get_free_lower_extent()
func inverted_position_on(node:Control, position:float):
	var length = get_free_size_on(node)
	return position

# Spacing
func cur_total_length():
	var length = 0
	for content_view in content_views:
		length += get_free_size_on(content_view)
	length += pb_space() * locked_pull_bar_count()
	return length
func pb_space():
	return pull_bar_thickness + spacing*2


# Rect Getters, Setters, and Adders

# Size Flags
func get_strict_size_flag(node:Control):
	match strict_axis:
		X_AXIS: return node.size_flags_horizontal
		Y_AXIS: return node.size_flags_vertical

# Anchor/Margin
func set_strict_filled_on(node:Control): set_axis_filled(node, strict_axis)

# Scale
func get_free_scale() -> float: return rect_scale[free_axis]
func set_free_scale(value:float): rect_scale[free_axis] = value
func set_free_scale_on(node:Control, value:float): node.rect_scale[free_axis] = value

# Pivot
func set_free_pivot(value:float): rect_pivot_offset[free_axis] = value
func set_free_pivot_on(node:Control, value:float): node.rect_pivot_offset[free_axis] = value

# Position
func get_free_position_on(node:Control): return node.rect_position[free_axis]
func set_free_position_on(node:Control, value:float): node.rect_position[free_axis] = value

# Size
func set_strict_size(value:float): rect_size[strict_axis] = value
func get_strict_size_on(node:Control): return node.rect_size[strict_axis]
	
func get_free_size() -> float: return rect_size[free_axis]
func set_free_size(value:float): 
	rect_size[free_axis] = value
	rect_pivot_offset[free_axis] = value/2
func get_free_size_on(node:Control) -> float: return node.rect_size[free_axis]
func add_to_free_size_on(node:Control, amount:float): node.rect_size[free_axis] += amount
func set_free_size_on(node:Control, value:float): node.rect_size[free_axis] = value

# Min Size
func get_strict_min_size() -> float: return rect_min_size[strict_axis]
func set_strict_min_size(value:float): rect_min_size[strict_axis] = value
func get_strict_min_size_on(node:Control): return node.rect_min_size[strict_axis]

func get_free_min_size() -> float: return max(rect_min_size[free_axis], 0 if not lock else get_lock_length())
func set_free_min_size(value:float): rect_min_size[free_axis] = value
func get_free_min_size_on(node:Control): return node.rect_min_size[free_axis]

# Max Size
func set_strict_max_size(value:float): rect_max_size[strict_axis] = value

func set_free_max_size(value:float): rect_max_size[free_axis] = value
func add_to_free_max_size(amount:float): rect_max_size[free_axis] += amount
func get_free_max_size() -> float: return min(rect_max_size[free_axis], 0 if not lock else get_lock_length())
func get_free_max_size_on(node:ContainerX) -> float: return node.rect_max_size[free_axis]


# Property Setters and Getters

func set_mcd(value:bool):
	match_content_depth = value
	align()
func get_mcd(): return match_content_depth
func set_invert(value:bool):
	invert = value
	align()
func get_invert(): return invert
func set_ltml(value:bool):
	lock_to_max_length = value
	align()
func get_ltml(): return lock_to_max_length
func set_ucll(value:bool):
	use_custom_lock_length = value
	align()
func get_ucll(): return use_custom_lock_length
func set_cll(value:float):
	custom_lock_length = value
	align()
func get_cll(): return custom_lock_length
func set_lock(value:bool):
	lock = value
	update_lock_length()
	align()
func get_lock(): return lock
func set_pbt(value:float):
	pull_bar_thickness = value
	align()
func get_pbt(): return pull_bar_thickness
func set_spacing(value:float):
	spacing = value
	align()
func get_spacing(): return spacing
func set_num(value:int): return
func get_num(): return size
