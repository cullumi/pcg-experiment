extends PanelContainer

class_name DisplayPanel

export (PackedScene) var nd_scene
export (int) var grid_width = 2

onready var grid = $item_panel/ScrollContainer/GridContainer
onready var label = $Label

signal node_selected
signal nodes_deselected

var node_displays:Array
var selected:int = -1
enum DESELECT {NODE=-1, ALL=-2}

func _ready():
	grid.columns = grid_width

func display_string(string:String):
	label.text = string

func replace_nodes(nodes:Array):
	clear_display()
	display_nodes(nodes)

func clear_display():
	for node_display in node_displays:
		node_display.queue_free()
	node_displays.clear()

func display_nodes(nodes:Array):
	for n in range(0, nodes.size()):
		var node = nodes[n]
		display_node(node, n)

func display_node(node, idx:int=-1):
	var node_display = nd_scene.instance()
	node_display.name = node.name
	grid.add_child(node_display)
	node_displays.append(node_display)
	node_display.initialize(false)
	node_display.set_node(node)
	node_display.connect("focus_entered", self, "select_node", [idx])
	node_display.connect("focus_exited", self, "deselect_node", [idx])

func select_node(node_idx:int):
	print("Node Selected:", node_idx)
	selected = node_idx
	emit_signal("node_selected", node_idx)

func deselect_node(node_idx:int):
	print("Node Deselected:", node_idx)
	selected = -1

func _on_display_panel_focus_entered():
	print("Display Panel Selected")
	if selected == DESELECT.NODE:
		print("Node(s) Deselected")
		selected = DESELECT.ALL
		emit_signal("nodes_deselected")
