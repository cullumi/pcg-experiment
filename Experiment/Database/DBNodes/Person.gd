extends DBNode

class_name Person

# warning-ignore:unused_signal
signal ping_roles
# warning-ignore:unused_signal
signal ping_skills
var roles:Array
var skills:Array

func get_skills(reqs:Dictionary={}):
	return ping("ping_skills", reqs, skills)

func get_roles(reqs:Dictionary={}):
	return ping("ping_roles", reqs, roles)
