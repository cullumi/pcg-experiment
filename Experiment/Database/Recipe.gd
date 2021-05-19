extends DBNode

class_name Recipe

signal ping_components
signal ping_processes
var components:Array
var processes:Array

func get_components(reqs:Dictionary={}):
	return ping("ping_components", reqs, components)

func get_processes(reqs:Dictionary={}):
	return ping("ping_processes", reqs, processes)

func pinged(source, reqs:Dictionary):
	var keys = reqs.keys()
	if keys.has("components"):
		if (not req_met("components", reqs, get_components())):return
	if keys.has("processes"):
		if (not req_met("processes", reqs, get_processes())):return
	source.pingback(self)
