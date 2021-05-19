extends Node

class_name DBNode

var results:Array

func get_ping(key:String, reqs:Dictionary={}):
	return ping("ping_"+key, reqs, [])

func has_key(key:String):
	return has_signal("ping_"+key)

func get_keys():
	var keys = []
	for sig in get_signal_list():
		if sig.name.begins_with("ping_"):
			keys.append(sig.name.trim_prefix("ping_"))
	return keys

func ping(ping_signal, reqs, dest):
	results = dest
	results.clear()
	emit_signal(ping_signal, self, reqs)
	return results

func pingback(result):
	results.append(result)

func pinged(source, reqs:Dictionary):
	print("Pinged...")
	if reqs.has("name"):
		if (not req_met("name", reqs, [name])):return
	for key in reqs.keys():
		if (has_key(key)):
			if (get_ping(key, reqs[key]).size() == 0): return
	print("Pinging Back...")
	source.pingback(self)

func req_met(key, reqs, source):
	var sub_reqs = reqs[key]
	for sub_req in sub_reqs:
#		print("\""+sub_req+"\"")
		if (not source.has(sub_req)): return false
	return true
