extends DBNode

class_name Recipe

# warning-ignore:unused_signal
signal ping_components
# warning-ignore:unused_signal
signal ping_processes
var components:Array
var processes:Array

func get_components(reqs:Dictionary={}):
	return ping("ping_components", reqs, components)

func get_processes(reqs:Dictionary={}):
	return ping("ping_processes", reqs, processes)
