extends Node

class_name DBNode

var results:Array

func get_ping(key:String, reqs:Dictionary={}):
	return ping("ping_"+key, reqs, [])

func ping(ping_signal, reqs, dest):
	results = dest
	results.clear()
	emit_signal(ping_signal, self, reqs)
	return results

func pingback(result):
	results.append(result)

func pinged(source, reqs):
	source.pingback(self)

func req_met(key, reqs, source):
	var sub_reqs = reqs[key]
	for sub_req in sub_reqs:
		if (not source.has(sub_req)): return false
	return true
