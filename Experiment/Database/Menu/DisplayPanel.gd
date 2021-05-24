extends PanelContainer

class_name DisplayPanel

onready var label = $Label

var type_copy = ""
var req_copy = {}

func update_display(type:String=type_copy, reqs:Dictionary=req_copy):
	print("Updating Display")
	if type == "": return
	var string = "Type: " + type + "\n"
	string += "Settings: "
	string = Strings.conc_item(string, reqs)
	string += "\n"
	var out = Database.get_ping(type, reqs)
	string = Strings.conc_item(string, out)
	label.text = string
	type_copy = type
	if reqs != req_copy:
		req_copy = reqs
