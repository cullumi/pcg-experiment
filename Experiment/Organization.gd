extends DBNode

class_name Organization

var org_id
var ind_ids:Array = []

signal ping_roles
var roles:Array
signal ping_products
var products:Array
signal ping_members
var members:Array

func get_roles(reqs:Dictionary={}):
	return ping("ping_roles", reqs, roles)

func get_products(reqs:Dictionary={}):
	return ping("ping_products", reqs, products)

func get_members(reqs:Dictionary={}):
	return ping("ping_members", reqs, members)

func pinged(source, reqs):
	match (reqs.type):
		"all":
			source.add_org(self)
		"org_id": 
			if (org_id == reqs.value): source.pingback(self)
		"ind_id":
			if (ind_ids.has(reqs.value)): source.pingback(self)
