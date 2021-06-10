extends SplitsContainer

class_name VSplitsContainer

export (bool) var test_delete = false
var triggered = true
var temp_child:Node

func align_children(equally_space:bool=false, size:float=rect_size.y):
	.align_children(equally_space, size)

func add_split(type=VSplitContainer):
	.add_split(type)

func _process(_delta):
	if test_delete == triggered:
		triggered = not triggered
		if test_delete:
			temp_child = get_children()[0]
			remove_child(temp_child)
		else:
			add_child(temp_child)	
	
