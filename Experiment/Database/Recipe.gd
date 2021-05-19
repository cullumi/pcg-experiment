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

#func pinged(source, reqs:Dictionary):
#	var keys = reqs.keys()
#	if keys.has("components"):
#		if (get_components(reqs.components).size() == 0): return
#	if keys.has("processes"):
#		if (get_processes(reqs.processes).size() == 0): return
#	source.pingback(self)
