tool

extends Container

class_name ContainerX

# Enums and Constants
enum {X_AXIS, Y_AXIS}
const NOMAX = -1

# Properties
export (bool) var use_backpanel = true
export (Vector2) var rect_max_size:Vector2 = Vector2(NOMAX, NOMAX) setget set_custom_max_size, get_custom_max_size
export (bool) var ignore_x_max = false
export (bool) var ignore_y_max = false

# Signals
signal child_removed(child)

# Variables
var backpanel:Panel
var extents:Rect2 = Rect2()


# Initialization

func _init():
	initialize_extents()

func _enter_tree():
	if use_backpanel:
		add_backpanel()

func initialize_extents():
	extents = Rect2(rect_position, rect_size)


# Overrides and Signals

func remove_child(child:Node):
	.remove_child(child)
	emit_signal("child_removed", child)

func _resized():
	if not ignore_x_max:
		rect_size.x = min(rect_size.x, self.rect_max_size.x)
	if not ignore_y_max:
		rect_size.y = min(rect_size.y, self.rect_max_size.y)
	if use_backpanel:
		update_backpanel()


# Backpanel

func add_backpanel():
	backpanel = Panel.new()
	.add_child(backpanel)
	.move_child(backpanel, 0)
	update_backpanel()

func update_backpanel():
	if name == "VAccordionContainerTest":
		print("Updating Backpanel")
	set_anchors(backpanel)
	set_margins(backpanel)


# Extents
func set_extents(new_extents:Rect2): extents = new_extents
func set_extent(axis:int, new_extents:Rect2):
	extents.position[axis] = new_extents.position[axis]
	extents.size[axis] = new_extents.size[axis]

# Anchors

func set_anchors(node:Control, l:float=0, r:float=1, t:float=0, b:float=1):
	set_h_anchors(node, l, r)
	set_v_anchors(node, t, b)

func set_h_anchors(node:Control, l:float=0, r:float=1):
	node.anchor_left = l
	node.anchor_right = r

func set_v_anchors(node:Control, t:float=0, b:float=0):
	node.anchor_top = t
	node.anchor_bottom = b


# Margins

func set_margins(node:Control, l:float=0, r:float=0, t:float=0, b:float=0):
	set_h_margins(node, l, r)
	set_v_margins(node, t, b)

func set_h_margins(node:Control, l:float=0, r:float=0):
	node.margin_left = l
	node.margin_right = r

func set_v_margins(node:Control, t:float=0, b:float=0):
	node.margin_top = t
	node.margin_bottom = b


# Anchor/Margin Fill

func set_axis_filled(node:Control, axis:int):
	match axis:
		X_AXIS: set_x_filled(node)
		Y_AXIS: set_y_filled(node)

func set_xy_filled(node:Control):
	set_x_filled(node)
	set_y_filled(node)

func set_x_filled(node:Control):
	set_h_anchors(node, 0, 1)
	set_h_margins(node, 0, 0)
	
func set_y_filled(node:Control):
	set_v_anchors(node, 0, 1)
	set_v_margins(node, 0, 0)


# Stretching

func stretch(node:Control, new_extents:Rect2, origins:Vector2=Vector2(), _debug=null):
	stretch_x(node, new_extents.position.x, new_extents.size.x, origins.x, _debug)
	stretch_y(node, new_extents.position.y, new_extents.size.y, origins.y, _debug)

func stretch_axis(node:Control, axis:int, position:float, length:float, origin:float=0, _debug=null):
	match axis:
		X_AXIS: stretch_x(node, position, length, origin, _debug)
		Y_AXIS: stretch_y(node, position, length, origin, _debug)
#		_: print("No Stretch ({axis})".format({"axis":axis}))

func stretch_x(node:Control, position:float, length:float, origin:float=0, _debug=null):
	var start = origin + position
	var left = start if length > 0 else start + length
	var right = start + length if length > 0 else start
#	if _debug != null:
#		prints("LR: {left} -> {right} ({pos} - {length}) ({debug})".format({
#		"left":left, "right":right, "pos":position, "length":length, "debug":_debug
#	}))
	set_h_anchors(node, 0, 0)
	set_h_margins(node, left, right)

func stretch_y(node:Control, position:float, length:float, origin:float=0, _debug=null):
	var start = origin + position
	var top = start if length > 0 else start + length
	var bottom = start + length if length > 0 else start
#	if _debug:
#		prints("LR: {top} -> {bottom} ({pos} - {length}) ({debug})".format({
#		"top":top, "bottom":bottom, "pos":position, "length":length, "debug":_debug
#	}))
	set_v_anchors(node, 0, 0)
	set_v_margins(node, top, bottom)


# Setters and Getters

func set_axis_ignore_max(axis:int, value:bool):
	match axis:
		X_AXIS: ignore_x_max = value
		Y_AXIS: ignore_y_max = value

func set_custom_max_size(value:Vector2):
	var vector = Vector2(
		NOMAX if value.x == INF else value.x,
		NOMAX if value.y == INF else value.y
	)
	rect_max_size = vector
func get_custom_max_size():
	if Engine.editor_hint:
		return rect_max_size
	else:
		return Vector2(
			INF if rect_max_size.x == NOMAX else rect_max_size.x,
			INF if rect_max_size.y == NOMAX else rect_max_size.y
		)
