extends DBNode

class_name Economy

# warning-ignore:unused_signal
signal ping_organizations

var orgs : Array

func get_org(org_id):
	return ping("ping_organizations", {"type":"org_id","value":org_id}, orgs)[0]

func get_orgs(ind_id):
	return ping("ping_organizations", {"type":"ind_id","value":ind_id}, orgs)
