extends DBNode

#class_name Database

var generator:Generator

var db_dict:Dictionary={}

func _init():
	generator = Generator.new()
	generator.name = "Generator"
	add_child(generator)

func _ready():
	db_dict = generator.initialize(self)
	generator.generate()
	initialize()

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

func initialize():
	var keys = db_dict.keys()
	for key in keys:
		add_user_signal("ping_"+key)
		for elem in db_dict[key]:
			connect("ping_"+key, elem, "pinged")
