extends DBNode

class_name Skill

# warning-ignore:unused_signal
signal ping_processes
var processes:Array

func get_processes(reqs:Dictionary={}):
	return ping("ping_processes", reqs, processes)
