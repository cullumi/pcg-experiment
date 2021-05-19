extends PanelContainer

onready var label = $Label

func update_display(type:String, reqs:Dictionary):
	print("Updating Display")
	var string = "Type: " + type + "\n"
	string += "Settings: {"
	for key in reqs.keys():
		string += key + ": "
		var req = reqs[key]
		if req is Array:
			string += "["
			for r in req:
				string += r + ", "
			string.trim_suffix(", ")
			string += "]"
		else:
			string += req
		string += ", "
		
	string.trim_suffix(", ")
	string += "}"
	print(string)
	print(Database.get_ping(type, reqs))
	label.text = string
