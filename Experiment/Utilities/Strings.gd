extends Object

class_name Strings

static func conc_dictionary(string, dict):
	string += "{"
	for key in dict.keys():
		string += key + ":"
		var req = dict[key]
		string = conc_item(string, req)
		string += ", "
		
	string = string.trim_suffix(", ")
	string += "}"
	return string

static func conc_item(string, item):
	match typeof(item):
		TYPE_ARRAY: string = conc_array(string, item)
		TYPE_DICTIONARY: string = conc_dictionary(string, item)
		TYPE_OBJECT: 
			if (item is Node): string += item.name
			else: string += item.to_string()
		TYPE_STRING: string += item
	return string

static func conc_array(string, array):
	string += "["
	for elem in array:
		string = conc_item(string, elem)
		string += ", "
	string = string.trim_suffix(", ")
	string += "]"
	return string
