extends ContainerX

class_name GridAccordionContainer

enum AXIS {HORIZONTAL=X_AXIS, VERTICAL=Y_AXIS}
enum {MINOR=0, MAJOR=1}
export (AXIS) var major_axis = AXIS.HORIZONTAL setget set_major, get_major
export (AXIS) var minor_axis = AXIS.VERTICAL setget set_minor, get_minor
export (int) var major_count = 3
export (int) var size setget set_num, get_num

func set_major(val:int):
	major_axis = val
	minor_axis = int(not val)
func get_major(): return major_axis
func set_minor(val:int):
	minor_axis = val
	major_axis = int(not val)
func get_minor(): return minor_axis

var vacs:Array = []
var hacs:Array = []
var contents:Array = []

var count = 0


# Initialization

func _enter_tree():
	initialize_major()
	for child in get_children():
		if child is Control:
			if child == backpanel: continue
			if contents.has(child): continue
			if vacs.has(child): continue
			if hacs.has(child): continue
			insert(child, false)
	align()

func initialize_major():
	add_mac(MAJOR)


# Alignment

func align():
	pass


# Insertion and Removal

func insert(content:Control, realign:bool=true, index:int=size):
	var idx = min(size, index)
	var major_idx = idx / major_count
	var minor_idx = idx % major_count
	
	var macs:Array = minors()
	if major_idx >= macs.size(): add_mac(MINOR)
	var mac:AccordionContainer = macs[major_idx]
	print(" ({mji},{mni}) ".format({"mji":major_idx, "mni":minor_idx}), Strings.to_names(get_children()))
	.remove_child(content)
	print(" ", Strings.to_names(get_children()))
	mac.add_child(content)
	contents.insert(idx, content)
	
	count += 1
	if realign: align()

func remove(content:Control, realign:bool=true):
	var par:AccordionContainer = find_content_parent(content)
	par.remove_child(content)
	if par.size <= 0:
		remove_mac(par)
	
	count -= 1
	
	if realign: align()


# Insertion and Removal Helpers

func update_mac_names():
	for i in range(0, vacs.size()):
		vacs[i].name = "VAC " + String(i)
	for i in range(0, hacs.size()):
		hacs[i].name = "HAC " + String(i)

func add_mac(major:bool):
	var mac:AccordionContainer = new_mac(major)
	mac.lock = true
	if major:
		majors().insert(0, mac)
		mac.set_extents(extents)
		mac.lock = true
		.add_child(mac)
		.move_child(mac, 1 if use_backpanel else 0)
		stretch(mac, mac.extents)
	else:
		minors().append(mac)
		mac.set_extent(minor_axis, extents)
		majors().front().add_child_below_node(minors().back(), mac)
	update_mac_names()

func remove_mac(mac:AccordionContainer):
	mac.get_parent().remove_child(mac)
	if is_major(mac): majors().erase(mac)
	elif is_minor(mac): minors().erase(mac)
	update_mac_names()

func find_content_parent(content:Control) -> AccordionContainer:
	var macs = minors()
	for m in macs:
		var mac:AccordionContainer = m
		if mac.contents.has(content):
			return mac
	return null

func new_mac(major:bool):
	var new:AccordionContainer
	if major: new = new_major()
	else: new = new_minor()
	return new

func new_major() -> AccordionContainer:
	var new:AccordionContainer
	match major_axis:
		AXIS.HORIZONTAL: new = new_h()
		AXIS.VERTICAL: new = new_v()
	new.use_backpanel = false
	return new

func new_minor() -> AccordionContainer:
	var new:AccordionContainer
	match major_axis:
		AXIS.VERTICAL: new = new_h()
		AXIS.HORIZONTAL: new = new_v()
	new.match_content_depth = true
	return new

func new_h() -> HAccordionContainer:
	var new = HAccordionContainer.new()
	new.name = "HAC"
	return new

func new_v() -> VAccordionContainer:
	var new = VAccordionContainer.new()
	new.name = "VAC"
	return new

func majors(): return hacs if major_axis == AXIS.HORIZONTAL else vacs
func minors(): return vacs if major_axis == AXIS.HORIZONTAL else hacs

func is_major(mac:AccordionContainer): return majors().has(mac)
func is_minor(mac:AccordionContainer): return minors().has(mac)

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


# Setters and Getters

func set_num(value:int): return
func get_num(): return size
