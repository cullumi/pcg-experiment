extends PanelContainer

class_name InteractionPanel

onready var node_display:NodeDisplay = $VBoxContainer/NodeDisplay
onready var new_button:Button = $FreeObjects/NewButton
onready var action_button:Button = $VBoxContainer/HBoxContainer/ActionButton
onready var reset_button:Button = $VBoxContainer/HBoxContainer/VBoxContainer/ResetButton
onready var delete_button:Button = $VBoxContainer/HBoxContainer/VBoxContainer/DeleteButton

signal new_node
signal node_edited
signal node_added
signal delete_node
signal tags_changed
signal tag_selected
signal tag_registered
signal tag_deregistered

var contents:Array = []
var editing = false

var saved_node
var node_name
var node_contents

func _ready():
	node_display.initialize(false)

func set_node(node):
	saved_node = node
	node_name = node.name
	node_contents = node.contents.duplicate(true)
	node_display.set_node(node)

func toggle(show=null):
	if show == null:
		visible = not visible
	else:
		visible = show

func set_edit(edit):
	editing = edit
	if edit:
		new_button.disabled = false
		action_button.text = "Save"
		delete_button.disabled = false
	else:
		new_button.disabled = true
		action_button.text = "Add"
		delete_button.disabled = true

func _on_NodeDisplay_name_changed(new_name:String):
	node_name = new_name

#func _on_NodeDisplay_value_changed(key:String, new_values):
#	node_contents[key] = new_values

func _on_NodeDisplay_tags_changed(new_tags):
	emit_signal("tags_changed", new_tags)

func _on_NodeDisplay_tag_selected(key:String, value:String):
	emit_signal("tag_selected", key, value)

func _on_NodeDisplay_tag_registered(key:String, value:String):
	emit_signal("tag_registered", key, value)

func _on_NodeDisplay_tag_deregistered(key:String, value:String):
	emit_signal("tag_deregistered", key, value)

func _on_NewButton_pressed():
	emit_signal("new_node")

func _on_ActionButton_pressed():
	if editing:
		emit_signal("node_edited", node_name, node_contents)
	else:
		emit_signal("node_added", node_name, node_contents)

func _on_ResetButton_pressed():
	set_node(saved_node)

func _on_DeleteButton_pressed():
	emit_signal("delete_node")
