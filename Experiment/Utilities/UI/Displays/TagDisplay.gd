extends VBoxContainer

onready var name_label = $Name
onready var tag_grid = $TagGrid

signal tag_selected

var tag_buttons:Array = []
var tags:Array

func add_tags(new_tags:Array, tag_options:Array):
	for tag in new_tags:
		add_tag(tag)

func add_tag(new_tag:String):
	var button:Button = Button.new()
	button.text = new_tag
	tag_buttons.append(button)
	tags.append(new_tag)
	tag_grid.add_child(button)
	button.connect("pressed", self, "_on_tagButton_pressed", [tags.size()-1])

func _on_tagButton_pressed(idx):
	emit_signal("tag_selected", idx)
