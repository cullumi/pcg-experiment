extends Control

class_name NodeDisplay

#export (PackedScene) var edit_content_scene
export (PackedScene) var display_content_scene
export (PackedScene) var tag_scene
var content_scene

onready var cd_list:DisplayList = $VBoxContainer/ScrollContainer/MarginContainer/VBoxContainer/ContentDisplayList
onready var td_list:DisplayList = $VBoxContainer/ScrollContainer/MarginContainer/VBoxContainer/TagDisplayList
onready var name_label = $VBoxContainer/NameLabel
onready var name_edit = $VBoxContainer/LineEdit

signal name_changed
signal value_changed
signal tags_changed
signal tag_selected
signal tag_registered
signal tag_deregistered

var separators:Array
var contents:Array
var tagsets:Array

var node_name
var editable

func realign():
	pass

func initialize(make_editable):
	editable = make_editable
	content_scene = display_content_scene
	if editable:
#		content_scene = edit_content_scene
		name_label.visible = false
		name_edit.visible = true
#		name_edit.connect("text_changed", self, "_on_nameEdit_changed")
	else:
#		content_scene = display_content_scene
		name_label.visible = true
		name_edit.visible = false

func set_node(node):
	node_name = node.name
#	var names = node.contents.keys()
#	var values = node.contents.values()
	var tag_keys = node.get_keys()
	var tag_values = []
	var tag_options = []
	for key in tag_keys:
		var sub = []
		for sn in node.get_ping(key):
			sub.append(sn.name)
		tag_values.append(sub)
		tag_options.append(DatabaseMenu.generate_filter_options(tag_keys))
	set_display(node_name, tag_keys, tag_values, tag_options)

func set_display(title:String, tag_keys:Array, tag_values:Array, tag_options:Array):
	set_title(title)
	cd_list.clear_items()
	td_list.clear_items()
	if editable:
#		var connections= []
#		connections.append(["value_changed", self, "_on_editableContent_changed"])
#		cd_list.add_items(names, values, content_scene, connections)
		
		var connections = []
		connections.append(["tags_changed", self, "_on_TagDisplay_tags_changed"])
		connections.append(["tag_selected", self, "_on_TagDisplay_tag_selected"])
		connections.append(["tag_registered", self, "_onTagDisplay_tag_registered"])
		connections.append(["tag_deregistered", self, "_onTagDisplay_tag_deregistered"])
		td_list.add_items(tag_keys, tag_values, tag_options, tag_scene, connections)
	else:
#		cd_list.add_items(names, values, content_scene)
		td_list.add_items(tag_keys, tag_values, tag_options, tag_scene)

func set_title(title:String):
	name = title
	name_label.text = title
	name_edit.text = title

func _on_nameEdit_changed(new_name:String):
	emit_signal("name_changed", new_name)

#func _on_editableContent_changed(key:String, new_value):
#	emit_signal("value_changed", key, new_value)

func _on_TagDisplay_tags_changed(new_tags):
	emit_signal("tags_changed", new_tags)

func _on_TagDisplay_tag_selected(key:String, value:String):
	emit_signal("tag_selected", key, value)

func _on_TagDisplay_tag_registered(key:String, value:String):
	emit_signal("tag_registered", key, value)

func _on_TagDisplay_tag_deregistered(key:String, value:String):
	emit_signal("tag_deregistered", key, value)
