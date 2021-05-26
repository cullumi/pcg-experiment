extends PanelContainer

class_name OptionsPanel

export (PackedScene) var dropdown_scene
export (bool) var types_builtin

onready var container = $GridContainer
var dropdowns:Array

signal filter_changed

var filter:Dictionary = {}
var setting_filter:bool = false

# Filters

func set_filter_options(filter_options):
	clear_dropdowns()
	for key in filter_options.keys():
		add_dropdown(key, filter_options[key])

func set_filter(new_filter):
	setting_filter = true
	filter = new_filter
	for dropdown in dropdowns:
		if filter.has(dropdown.name):
			dropdown.set_selected(filter[dropdown.name])
		else:
			dropdown.set_selected(0)
	setting_filter = false

func set_option(option:String, key:String):
	if option == "(any)":
		filter.erase(key)
	else:
		filter[key] = option
	if not setting_filter:
		emit_signal("filter_changed", filter)

# Dropdowns

func clear_dropdowns():
	for dd in dropdowns:
		dd.name = "-1"
		dd.queue_free()
	dropdowns.clear()

func add_dropdown(key:String, options:Array):
	var dropdown:Dropdown = dropdown_scene.instance()
	options.push_front("(any)")
	dropdown.initialize(key, options)
	container.add_child(dropdown)
	dropdowns.append(dropdown)
	dropdown.connect("item_selected", self, "set_option", [key])
