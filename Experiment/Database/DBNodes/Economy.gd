extends DBNode

class_name Economy

# warning-ignore:unused_signal
signal ping_orgs

var orgs : Array

func get_org(org_id):
	return ping("ping_orgs", {"type":"org_id","value":org_id}, orgs)[0]

func get_orgs(ind_id):
	return ping("ping_orgs", {"type":"ind_id","value":ind_id}, orgs)
