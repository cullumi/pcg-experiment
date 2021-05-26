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
	print("Getting Dependencies")
	var struct:Dictionary = generator.structure
	var result:Dictionary = {}
	get_dep_rec(key, result, struct)
	return result

func get_dep_rec(key, result:Dictionary, struct:Dictionary, path:Array=[]):
	# Prepare Path
	path.append(key)
	var link_path = path.duplicate()
	path.pop_front()
	path.append("name")
	# Add Path to Result
	if not result.has(key):
		result[key] = []
	result[key].append(path)
	# Dive into Dependencies
	for d in struct[key].dependencies:
		get_dep_rec(d, result, struct, link_path.duplicate())

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

# Req Recursion

func generate_ping_reqs(filter, dependencies):
	var reqs = {}
	for key in filter.keys():
		addset_req(key, filter[key], reqs, dependencies)
	return reqs
	
func erase_req(key, option, reqs:Dictionary, dependencies:Dictionary):
	var paths = dependencies[key]
	for path in paths:
		print(path)
		Dicts.recursive_erase(path, 0, reqs)

func addset_req(key, option, reqs:Dictionary, dependencies:Dictionary):
	var paths = dependencies[key]
	var start_dict = reqs
	var current_dict
	for path in paths:
		current_dict = start_dict
		var p:int = 0
		for step in path:
			p += 1
			if (p < path.size()):
				if (not current_dict.has(step)):
					current_dict[step] = {}
				current_dict = current_dict[step]
			else:
				current_dict[step] = [option]
