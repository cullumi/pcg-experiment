extends DBNode

class_name Organization

var o_contents = {
	"org_id":[],
	"ind_id":[],
}

# warning-ignore:unused_signal
signal ping_roles
var roles:Array
# warning-ignore:unused_signal
signal ping_products
var products:Array
# warning-ignore:unused_signal
signal ping_members
var members:Array

func _init():
	contents = o_contents

func get_roles(reqs:Dictionary={}):
	return ping("ping_roles", reqs, roles)

func get_products(reqs:Dictionary={}):
	return ping("ping_products", reqs, products)

func get_members(reqs:Dictionary={}):
	return ping("ping_members", reqs, members)
