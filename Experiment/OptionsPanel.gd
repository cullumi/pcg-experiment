extends PanelContainer

class_name OptionsPanel

onready var container = $HBoxContainer
var type_dropdown
var dropdowns:Array

signal settings_changed
var type:String
var reqs:Dictionary = {}

var types:Array = []
var settings:Dictionary = {}
var dependencies:Dictionary = {}

func initialize():
	types = Database.get_keys()
	type_dropdown = add_dropdown("type", types, "set_type")
	type = types[0]
	update_settings()

func update_settings():
	clear_dropdowns()
	reqs.clear()
	settings.clear()
	dependencies = Database.get_dependencies(type)
	for key in dependencies.keys():
		var ops = Database.get_ping(key)
		var setting = []
		setting.append("(any)")
		for op in ops: setting.append(op.name)
		settings[key] = setting
		dropdowns.append(add_dropdown(key, setting, "set_option", [key]))
	emit_signal("settings_changed", type, reqs)

func clear_dropdowns():
	for dd in dropdowns:
		dd.queue_free()
	dropdowns.clear()

func add_dropdown(key, op_keys, select_signal, binds=[]):
	var hbox = HBoxContainer.new()
	var lbl = Label.new()
	var lsptr = VSeparator.new()
	var rsptr = VSeparator.new()
	var dd:OptionButton = OptionButton.new()
	lbl.text = key
	for op in op_keys:
		dd.add_item(op)
	dd.connect("item_selected", self, select_signal, binds)
	container.add_child(hbox)
	hbox.add_child(lsptr)
	hbox.add_child(lbl)
	hbox.add_child(dd)
	hbox.add_child(rsptr)
	return hbox

func set_type(type_index:int):
	var new_type = types[type_index]
	type = new_type
	update_settings()

func set_option(opt_index:int, setting:String):
	var option = settings[setting][opt_index]
	if (option != "(any)"):
		set_req(setting, option)
#		reqs[setting] = {"name":[option]}
	else:
		erase_req(setting, option)
#		reqs.erase(setting)
	emit_signal("settings_changed", type, reqs)

func erase_req(setting, option):
	var paths = dependencies[setting]
	for path in paths:
		rec_erase_req(path, 0, reqs)

func rec_erase_req(path:Array, cur_index:int, current_dict:Dictionary):
	if cur_index >= path.size():
		current_dict.clear()
		return
	var key = path[cur_index]
	if (current_dict.has(key)):
		rec_erase_req(path, cur_index+1, current_dict[key])
		if current_dict[key].empty():
			current_dict.erase(key)

func set_req(setting, option):
	var paths = dependencies[setting]
	var start_dict = reqs
	var current_dict
	for path in paths:
		current_dict = start_dict
		for step in path:
			if (not current_dict.has(step)):
				current_dict[step] = {}
			current_dict = current_dict[step]
		current_dict["name"] = [option]
