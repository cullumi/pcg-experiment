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

func initialize():
	var keys = db_dict.keys()
	for key in keys:
		add_user_signal("ping_"+key)
		for elem in db_dict[key]:
			connect("ping_"+key, elem, "pinged")
