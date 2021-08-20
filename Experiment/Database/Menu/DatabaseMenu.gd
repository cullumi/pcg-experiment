extends Container

onready var navTabs:NavTabs = $VBoxContainer/NavTabs
onready var options:OptionsPanel = $VBoxContainer/OptionPanel
onready var display:DisplayPanel = $VBoxContainer/HBoxContainer/DisplayPanel
onready var interaction:InteractionPanel = $VBoxContainer/HBoxContainer/InteractionPanel

var node_type:String
var filter:Dictionary
var filter_options:Dictionary
var dependencies:Dictionary
var reqs:Dictionary
var nodes:Array
var selected_node:DBNode
var editing:bool = false

#var filter_changed:bool = false
var node_type_changed:bool = false

func _ready():
	navTabs.initialize(Database.get_keys())

func update_menu():
	if (node_type_changed):
		dependencies = Database.get_dependencies(node_type)
		filter_options = generate_filter_options(dependencies.keys())
		options.set_filter_options(filter_options)
		selected_node = Database.get_new(node_type)
		editing = false
		interaction.set_node(selected_node)
		interaction.set_edit(false)
		node_type_changed = false
	options.set_filter(filter)
	reqs = Database.generate_ping_reqs(filter, dependencies)
	nodes = Database.get_ping(node_type, reqs)
	print(nodes)
	display.replace_nodes(nodes)
	var d_string = Strings.from_item(nodes) + "\n"
	d_string += Strings.from_item(navTabs.saved_filters) + "\n"
	d_string += Strings.from_item(filter) + "\n"
	d_string += Strings.from_item(reqs)
	display.display_string(d_string)

func generate_filter_options(keys):
	var fil_ops = {}
	for key in keys:
		var ops = Strings.to_names(Database.get_ping(key))
		fil_ops[key] = ops
	return fil_ops

func set_type(new_type):
	if node_type != new_type:
		node_type = new_type
		node_type_changed = true
		filter = {}
		return true
	return false

func _on_NavTabs_tab_changed(new_type, new_filter=null):
	set_type(new_type)
	print(new_filter)
	filter = new_filter
	update_menu()

func _on_OptionPanel_filter_changed(new_filter):
	filter = new_filter
	navTabs.save_filter(new_filter)
	update_menu()

func select_node(node_idx):
	var node:DBNode = nodes[node_idx]
	if not editing:
		selected_node.queue_free()
	selected_node = node
	editing = true
#	print("Old Node:", node.to_string())
	interaction.set_node(node)
	interaction.set_edit(true)

func select_new():
	var node:DBNode = Database.get_new(node_type)
	selected_node = node
	editing = false
#	print("New Node:", node.to_string())
	interaction.set_node(node)
	interaction.set_edit(false)

func _on_InteractionPanel_node_added(new_name, new_contents):
#	print("Adding Node:", new_name, " / ", selected_node)
	selected_node.name = new_name
	selected_node.contents = new_contents
	Database.add_node(node_type, selected_node)
	editing = true
	interaction.set_edit(true)
	update_menu()

func _on_InteractionPanel_node_edited(new_name, new_contents):
#	print("Editing Node:", new_name, " / ", selected_node)
	selected_node.name = new_name
	selected_node.contents = new_contents
	update_menu()

func _on_InteractionPanel_delete_node():
	selected_node.destroy()
	select_new()
	update_menu()
