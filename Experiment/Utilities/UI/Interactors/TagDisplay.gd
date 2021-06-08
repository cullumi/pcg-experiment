extends VBoxContainer

export (bool) var no_duplicates = true

onready var name_label:Label = $Name
onready var tag_grid:GridContainer = $HBoxContainer/TagGrid
onready var dropdown:Dropdown = $HBoxContainer/Dropdown

signal tag_selected

var tag_buttons:Array = []
var tags:Array
var tag_options:Array

func initialize(new_tags:Array, new_tag_options:Array=[]):
	add_tags(new_tags)
	set_tag_options(new_tag_options)

func set_tag_options(new_tag_options:Array):
	tag_options = new_tag_options
	dropdown.visible = tag_options.empty()

func add_tags(new_tags:Array):
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
