extends Control

export (PackedScene) var content_scene

onready var container = $VBoxContainer
onready var name_label = $VBoxContainer/NameLabel

var separators:Array
var contents:Array

var node_name

func initialize(n_name:String):
	name = n_name
	node_name = n_name
	name_label.text = node_name

#func _ready():
#	name_label.text = node_name

func add_contents(c_names:Array, c_arrs:Array):
	for i in range(0, c_names.size()):
		add_content(c_names[i], c_arrs[i])

func add_content(c_name:String, c_arr:Array):
	if contents.size() != 0:
		var separator:HSeparator = HSeparator.new()
		container.add_child(separator)
		separators.append(separator)
	var c_value = Strings.conc_array("", c_arr)
	var content = content_scene.instance()
	content.initialize(c_name, c_value)
	container.add_child(content)
	contents.append(content)
