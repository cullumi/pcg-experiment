extends PanelContainer

onready var container = $HBoxContainer
var type:String
var dropdowns:Array

signal settings_changed
var reqs:Dictionary = {}
var settings:Dictionary = {}

func update_settings():
	clear_dropdowns()
	reqs.clear()
	settings.clear()
	var deps = Database.get_dependencies(type)
	for dep in deps:
		settings[dep] = []
		var ops = Database.get_ping(dep)
		settings[dep].append("(any)")
		for op in ops:
			settings[dep].append(op.name)
		add_dropdown(dep)
	emit_signal("settings_changed", type, reqs)

func clear_dropdowns():
	for dd in dropdowns:
		dd.queue_free()
	dropdowns.clear()

func add_dropdown(key):
	var hbox = HBoxContainer.new()
	var lbl = Label.new()
	var lsptr = VSeparator.new()
	var rsptr = VSeparator.new()
	var dd:OptionButton = OptionButton.new()
	lbl.text = key
	var ops = settings[key]
	for op in ops:
		dd.add_item(op)
	dd.connect("item_selected", self, "set_option", [key])
	container.add_child(hbox)
	hbox.add_child(lsptr)
	hbox.add_child(lbl)
	hbox.add_child(dd)
	hbox.add_child(rsptr)
	dropdowns.append(hbox)

func set_type(type:String):
	self.type = type
	if (Database.has_key(type)):
		update_settings()

func set_option(opt_index:int, setting:String):
	var option = settings[setting][opt_index]
	if (option != "(any)"):
		reqs[setting] = [option]
	else:
		reqs.erase(setting)
	emit_signal("settings_changed", type, reqs)
