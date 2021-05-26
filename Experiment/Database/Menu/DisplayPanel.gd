extends PanelContainer

class_name DisplayPanel

export (PackedScene) var nd_scene

onready var grid = $item_panel/ScrollContainer/GridContainer
onready var label = $Label

var node_displays:Array

var type_copy:String = ""
var req_copy:Dictionary = {}

func clear_display():
	for node_display in node_displays:
		node_display.queue_free()
	node_displays.clear()

func add_node_displays(nodes):
	for node in nodes:
		add_node_display(node.name, node.contents.keys(), node.contents.values())

func add_node_display(node_name:String, content_names:Array, content_arrays:Array):
	var node_display = nd_scene.instance()
	grid.add_child(node_display)
	node_displays.append(node_display)
	node_display.initialize(node_name)
	node_display.add_contents(content_names, content_arrays)

func update_display(type:String=type_copy, reqs:Dictionary=req_copy):
	print("Updating Display")
	clear_display()
	if type == "": return
	var string = "Type: " + type + "\n"
	string += "Settings: "
	string = Strings.conc_item(string, reqs)
	string += "\n"
	var out = Database.get_ping(type, reqs)
	string = Strings.conc_item(string, out)
	label.text = string
	add_node_displays(out)
	type_copy = type
	if reqs != req_copy:
		req_copy = reqs
