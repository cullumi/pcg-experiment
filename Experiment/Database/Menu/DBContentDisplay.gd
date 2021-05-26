extends HBoxContainer

onready var name_label = $NameLabel
onready var value_label = $ValueLabel

var value:String

func initialize(c_name:String, c_value:String):
	name = c_name
	value = c_value

func _ready():
	name_label.text = name
	value_label.text = value
