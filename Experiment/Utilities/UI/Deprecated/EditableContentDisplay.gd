extends HBoxContainer

onready var name_label = $NameLabel
onready var value_grid = $VFixedContainer/ValueBody
onready var add_button = $ButtonBar/AddValue
onready var remove_button = $ButtonBar/RemoveValue

signal value_changed

var edits:Array = []
var values:Array

var selected_idx:int = -1

func initialize(c_name:String, c_values:Array):
	name = c_name
	values = c_values.duplicate()

func _ready():
	name_label.text = name
	add_values(values)

func add_values(new_values):
	for value in new_values:
		add_value(value)

func add_value(value):
	var edit:LineEdit = LineEdit.new()
	edit.text = value
	value_grid.add_child(edit)
	edits.append(value)
	remove_button.disabled = false
# warning-ignore:return_value_discarded
	edit.connect("text_changed", self, "_onValueEdit_text_changed", [edits.size()-1])

func insert_value(idx, value):
	var edit:LineEdit = LineEdit.new()
	edit.rect_min_size = edit.rect_size
	edit.size_flags_horizontal = SIZE_FILL
	edit.size_flags_vertical = SIZE_FILL
	edit.expand_to_text_length = true
	edit.text = value
	if edits.size() > 0:
		value_grid.add_child_below_node(edits[idx-1], edit)
		edits.insert(idx, edit)
		values.insert(idx, value)
	else:
		value_grid.add_child(edit)
		edits.append(edit)
		values.append(value)
# warning-ignore:return_value_discarded
	edit.connect("text_changed", self, "_on_ValueEdit_text_changed", [idx])
	if (idx >= edits.size()):
		reset_binds_in_range(range(idx+1, edits.size()))

func remove_value(idx):
	var edit = edits[idx]
	values.remove(idx)
	edits.remove(idx)
	if edit is Node:
		edit.queue_free()
	if (edits.size()-idx >= 1):
		reset_binds_in_range(range(idx, edits.size()))

func reset_binds_in_range(edit_range):
	for e in edit_range:
		edits[e].disconnect("text_changed", self, "_on_ValueEdit_text_changed")
		edits[e].connect("text_changed", self, "_on_valueEdit_text_changed", [e])

func _on_ValueEdit_text_changed(new_text, value_idx):
	values[value_idx] = new_text
	emit_signal("value_changed", name, values)

func _on_AddValue_pressed():
	var idx = (edits.size()-1 if selected_idx < 0 else selected_idx) + 1
	insert_value(idx, "")
	remove_button.disabled = false
	emit_signal("value_changed", name, values)

func _on_RemoveValue_pressed():
	if not edits.empty():
		var idx = edits.size()-1 if selected_idx < 0 else selected_idx
		remove_value(idx)
		if edits.empty():
			remove_button.disabled = true
		emit_signal("value_changed", name, values)
