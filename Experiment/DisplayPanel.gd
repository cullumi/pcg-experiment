extends PanelContainer

class_name DisplayPanel

onready var label = $Label

func update_display(type:String, reqs:Dictionary):
	print("Updating Display")
	var string = "Type: " + type + "\n"
	string += "Settings: "
	string = Strings.conc_item(string, reqs)
	string += "\n"
	var out = Database.get_ping(type, reqs)
	string = Strings.conc_item(string, out)
	print(string)
	label.text = string


