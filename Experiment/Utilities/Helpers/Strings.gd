extends Object

class_name Strings

static func to_names(array:Array):
	var names:Array = []
	for elem in array:
		names.append(elem.name)
	return names

static func from_dictionary(dict:Dictionary, string:String=""):
	string += "{"
	for key in dict.keys():
		string += key + ":"
		var req = dict[key]
		string = from_item(req, string)
		string += ", "
		
	string = string.trim_suffix(", ")
	string += "}"
	return string

static func from_item(item, string:String=""):
	match typeof(item):
		TYPE_ARRAY: string = from_array(item, string)
		TYPE_DICTIONARY: string = from_dictionary(item, string)
		TYPE_OBJECT: 
			if (item is Node): string += item.name
			else: string += item.to_string()
		TYPE_STRING: string += item
	return string

static func from_array(array:Array, string:String=""):
	string += "["
	for elem in array:
		string = from_item(elem, string)
		string += ", "
	string = string.trim_suffix(", ")
	string += "]"
	return string
