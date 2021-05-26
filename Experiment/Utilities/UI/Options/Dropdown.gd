extends HBoxContainer

class_name Dropdown

export (bool) var toggle_mode = true

signal item_selected

onready var label = $Label
onready var option_button = $OptionButton

var options:Array = []
var readied:bool = false
var populated:bool = false
var initialized:bool = false

func initialize(d_name, d_options):
	name = d_name
	options = d_options
	if readied: populate()
	initialized = true

func _ready():
	option_button.toggle_mode = toggle_mode
	readied = true
	if initialized:
		populate()

func populate():
	if populated: return
	populated = true
	label.text = name
	for op in options:
		option_button.add_item(op)
	option_button.connect("item_focused", self, "_on_item_focused")
	option_button.connect("item_selected", self, "_on_item_selected")
	option_button.connect("pressed", self, "_on_pressed")

func set_selected(option):
	var index = option
	if option is String:
		index = get_option_index(option)
	option_button.select(index)

func get_option_index(option:String):
	for i in range(0, option_button.get_item_count()):
		if option == option_button.get_item_text(i): return i
	return -1

func _on_pressed():
	print("Option Pressed")

func _on_item_focused(opt_idx:int):
	print("Item Focused")

func _on_item_selected(opt_idx:int):
	print("Item Selected")
	emit_signal("item_selected", options[opt_idx])
