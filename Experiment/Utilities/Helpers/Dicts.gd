extends Object

class_name Dicts

static func recursive_erase(path:Array, cur_index:int, current_dict:Dictionary):
	if cur_index+1 >= path.size():
		current_dict.erase(path[cur_index])
	else:
		var key = path[cur_index]
		if (current_dict.has(key)):
			recursive_erase(path, cur_index+1, current_dict[key])
			if current_dict[key].empty():
				current_dict.erase(key)
