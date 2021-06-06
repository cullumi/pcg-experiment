extends Node

class_name DBNode

var contents:Dictionary={}
var results:Array
var destroyed

func destroy():
	destroyed = true
	queue_free()

func to_string():
	return "("+name+") "+String(contents)

func get_ping(key:String, reqs:Dictionary={}):
	return ping("ping_"+key, reqs, [])

func connect_ping(key:String, target:DBNode):
# warning-ignore:return_value_discarded
	connect("ping_"+key, target, "pinged");

func has_key(key:String):
	return has_signal("ping_"+key)

func get_keys():
	var keys = []
	for sig in get_signal_list():
		if sig.name.begins_with("ping_"):
			keys.append(sig.name.trim_prefix("ping_"))
	return keys

func ping(ping_signal, reqs, dest=[]):
	results = dest
	results.clear()
	emit_signal(ping_signal, self, reqs)
	return results

func pingback(result):
	results.append(result)

func pinged(source, reqs:Dictionary):
	if destroyed: return
	if reqs.has("name"):
		if (not req_met("name", reqs, [name])): return
	if reqs.has("contents"):
		if (not reqs_met("contents", reqs, contents)): return
	for key in reqs.keys():
		if (has_key(key)):
			if (get_ping(key, reqs[key]).size() == 0): return
	source.pingback(self)

func reqs_met(key, reqs, source:Dictionary) -> bool:
	for sub_key in reqs[key].keys():
		if reqs_met(sub_key, reqs[sub_key], source[sub_key]): return true
	return false

func req_met(key, reqs, source:Array) -> bool:
	for sub_req in reqs[key]:
		if source is Array:
			if (not source.has(sub_req)): return false
	return true
