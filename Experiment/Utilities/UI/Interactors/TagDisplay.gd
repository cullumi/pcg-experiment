extends VBoxContainer

export (bool) var no_duplicates = true

onready var name_label:Label = $Name
onready var tag_grid:GridContainer = $HBoxContainer/TagGrid
onready var dropdown:Dropdown = $HBoxContainer/Dropdown

signal tag_selected
signal tags_changed

var tag_buttons:Array = []
var tags:Array
var tag_options:Array

var ts=[]
var tos=[]

func initialize(new_name:String, new_tags:Array, new_tag_options:Array=[]):
	name = new_name
	ts = new_tags
	tos = new_tag_options

func _ready():
	set_name(name)
	add_tags(ts)
	set_tag_options(tos)

func set_name(new_name):
	name = new_name
	name_label.text = name

func set_tag_options(new_tag_options:Array):
	tag_options = new_tag_options
	dropdown.visible = not tag_options.empty()

func add_tags(new_tags:Array):
	for tag in new_tags:
		add_tag(tag)

func add_tag(new_tag:String):
	var button:Button = Button.new()
	button.text = new_tag
	tag_buttons.append(button)
	tags.append(new_tag)
	tag_grid.add_child(button)
# warning-ignore:return_value_discarded
	button.connect("pressed", self, "_on_tagButton_pressed", [new_tag])

func _on_tagButton_pressed(value):
	emit_signal("tag_selected", name, value)
