extends DBNode

class_name Skill

signal ping_processes
var processes:Array

func get_processes(reqs:Dictionary={}):
	return ping("ping_processes", reqs, processes)

func pinged(source, reqs:Dictionary):
	var keys = reqs.keys()
	if keys.has("processes"):
		if (not req_met("processes", reqs, get_processes())):return
	source.pingback(self)
