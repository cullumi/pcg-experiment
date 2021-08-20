tool

extends ContainerX

class_name ContentView

var contents:Array = []

func _init(clip=true):
	rect_clip_content = clip

func _clips_input():
	return true

func add_satelite_child(child:Node): 
	if child is Control:
		contents.append(child)
		update_rect_max()

func add_child(child:Node, legible_unique_name:bool=false):
	.add_child(child, legible_unique_name)
	if child is Control:
		contents.append(child)
		update_rect_max()

func update_rect_max():
	rect_max_size = Vector2()
	var leftmost_margin = INF
	var rightmost_margin = -INF
	var topmost_margin = INF
	var bottommost_margin = -INF
	for content in contents:
		set_anchors(content, 0, 0, 0, 0)
		leftmost_margin = min(leftmost_margin, content.margin_left)
		rightmost_margin = max(rightmost_margin, content.margin_right)
		topmost_margin = min(topmost_margin, content.margin_top)
		bottommost_margin = max(bottommost_margin, content.margin_bottom)
	rect_max_size.x = rightmost_margin-leftmost_margin
	rect_max_size.y = bottommost_margin-topmost_margin
