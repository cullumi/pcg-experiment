extends DBNode

class_name Person

signal ping_roles
signal ping_skills
var roles:Array
var skills:Array

func get_skills(reqs:Dictionary={}):
	return ping("ping_skills", reqs, skills)

func get_roles(reqs:Dictionary={}):
	return ping("ping_roles", reqs, roles)

func pinged(source, reqs:Dictionary):
	var keys = reqs.keys()
	if (keys.has("processes")):
		if get_skills({"processes":reqs.processes}).size()==0: return
	if (keys.has("skills")):
		if (not req_met("skills", reqs, get_skills())):return
	if (keys.has("roles")):
		if (not req_met("roles", reqs, get_roles())):return
	source.add_member(self)
