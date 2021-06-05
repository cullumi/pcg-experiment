extends Object

func parse_item(string:String):
	if string.begins_with("{"):
		return parse_dict(string)
	elif string.begins_with("["):
		return parse_array(string)

func parse_array(string:String):
	var array:Array = []
	var arrs:int = 0
	var dicts:int = 0
	var sub_start = null
	var stripped = string.lstrip("[").rstrip("]")
	while (true):
		var dict_start = stripped.find("{")
		var dict_end = stripped.find("}")
	return array

func findDict(string):
	pass

func parse_dict(string:String):
	var dict:Dictionary = {}
	var arrs:int = 0
	var dicts:int = 0
	var sub_start = null

#	match typeof():
#		TYPE_ARRAY: string = from_array(item, string)
#		TYPE_DICTIONARY: string = from_dictionary(item, string)
#		TYPE_OBJECT: 
#			if (item is Node): string += item.name
#			else: string += item.to_string()
#		TYPE_STRING: string += item
#	return string
