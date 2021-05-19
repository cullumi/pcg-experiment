extends DBNode

class_name Product

var description:String

signal ping_recipes
var recipes:Array

func get_recipes(reqs:Dictionary):
	return ping("ping_recipes", reqs, recipes)

#func pinged(source, reqs:Dictionary):
#	var keys = reqs.keys()
#	if keys.has("recipes"):
#		if (get_recipes(reqs) == 0):return
#	source.pingback(self)
