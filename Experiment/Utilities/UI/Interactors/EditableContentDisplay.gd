extends HBoxContainer

onready var name_label = $NameLabel
onready var value_edit = $ValueEdit

signal value_changed

var edits:Array = []
var new_values:Array

func initialize(c_name:String, c_values:Array):
	name = c_name
	new_values = c_values

func _ready():
	name_label.text = name
	add_values(new_values)

func add_values(values):
	for value in values:
		add_value(value)

func add_value(value):
	var edit:TextEdit = TextEdit.new()
	add_child(edit)
	edit.text = value
	edits.append(value)
# warning-ignore:return_value_discarded
	edit.connect("text_entered", self, "_onValueEdit_text_entered", [edits.size()-1])

func _on_ValueEdit_text_entered(new_text, value_idx):
	emit_signal("value_changed", new_text, value_idx)
