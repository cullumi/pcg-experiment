extends DBNode

class_name Product

var description:String

# warning-ignore:unused_signal
signal ping_recipes
var recipes:Array

func get_recipes(reqs:Dictionary):
	return ping("ping_recipes", reqs, recipes)
