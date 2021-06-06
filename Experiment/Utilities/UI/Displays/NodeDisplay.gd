extends Control

class_name NodeDisplay

export (PackedScene) var edit_content_scene
export (PackedScene) var display_content_scene
var content_scene

onready var container = $VBoxContainer
onready var name_label = $VBoxContainer/NameLabel
onready var name_edit = $VBoxContainer/LineEdit

signal name_changed()
signal value_changed()

var separators:Array
var contents:Array

var node_name

func initialize(editable):
	if editable:
		content_scene = edit_content_scene
		name_label.visible = false
		name_edit.visible = true
		name_edit.connect("text_changed", self, "_on_nameEdit_changed")
	else:
		content_scene = display_content_scene
		name_label.visible = true
		name_edit.visible = false

func set_node(node):
	set_display(node.name, node.contents.keys(), node.contents.values())

func set_display(new_name:String, c_names:Array, c_arrs:Array):
	set_name(new_name)
	clear_contents()
	add_contents(c_names, c_arrs)

func set_name(new_name:String):
	name = new_name
	node_name = new_name
	name_label.text = new_name
	name_edit.text = new_name

func clear_contents():
	for content in contents:
		content.name = "X"
		content.queue_free()
	contents.clear()
	for separator in separators:
		separator.queue_free()
	separators.clear()

func add_contents(c_names:Array, c_arrs:Array):
	for i in range(0, c_names.size()):
		add_content(c_names[i], c_arrs[i])

func add_content(c_name:String, c_arr:Array):
	if contents.size() != 0:
		var separator:HSeparator = HSeparator.new()
		container.add_child(separator)
		separators.append(separator)
	var content = content_scene.instance()
	content.initialize(c_name, c_arr)
	container.add_child(content)
	contents.append(content)
	if content.has_signal("value_changed"):
		content.connect("value_changed", self, "_on_editablContent_changed")

func _on_nameEdit_changed(new_name:String):
	emit_signal("name_changed", new_name)

func _on_editableContent_changed(key:String, new_value:String):
	emit_signal("value_changed", key, new_value)
