extends DBNode

#class_name Database

var generator:Generator

var db_dict:Dictionary={}

func _init():
	generator = Generator.new()
	generator.name = "Generator"
	add_child(generator)

func _ready():
	initialize()

func initialize():
	if not db_dict.empty():
		print("Clearing Database.")
		clear_database()
	print("Generating Database")
	db_dict = generator.initialize(self)
	generator.generate()
	print("Generating Pings")
	generate_pings()

func get_dependencies(key):
	var deps = generator.dependencies
	var result:Dictionary = {}
	get_dep_rec(key, result, deps)
	return result

func get_dep_rec(key, result:Dictionary, deps, path:Array=[]):
	path.append(key)
	if deps[key].empty():
		if not result.has(key):
			result[key] = []
		path.pop_front()
		result[key].append(path)
		return
	for d in deps[key]:
		get_dep_rec(d, result, deps, path.duplicate())

func generate_pings():
	var keys = db_dict.keys()
	for key in keys:
		if not has_user_signal("ping_"+key):
			add_user_signal("ping_"+key)
		for elem in db_dict[key]:
# warning-ignore:return_value_discarded
			connect("ping_"+key, elem, "pinged")

func clear_database():
	var keys = db_dict.keys()
	for key in keys:
		for node in db_dict[key]:
# warning-ignore:return_value_discarded
			disconnect("ping_"+key, node, "pinged")			
			node.queue_free()
	db_dict.clear()
