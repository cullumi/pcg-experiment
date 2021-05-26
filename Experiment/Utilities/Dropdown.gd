extends HBoxContainer

class_name Dropdown

signal item_selected

onready var label = $Label
onready var option_button = $OptionButton

var options:Array

func initialize(d_name, d_options):
	name = d_name
	options = d_options

func _ready():
	label.text = name
	for op in options:
		option_button.add_item(op)
	option_button.connect("item_selected", self, "_on_item_selected")

func _on_item_selected(index:int):
	emit_signal("item_selected", index)
