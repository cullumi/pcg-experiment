extends Tabs

class_name TabsPanel

var types:Array

func initialize(options):
	types = Database.get_keys()
	options.types = types
	for type in types:
		add_tab(type)
	connect("tab_changed", options, "set_type")
	options.set_type(types[0])
