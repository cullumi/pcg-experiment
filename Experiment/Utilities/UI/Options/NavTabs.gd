extends HBoxContainer

class_name NavTabs

onready var tabs:Tabs = $Tabs
onready var dropdown:Dropdown = $Dropdown

signal tab_changed

var displayed_keys:Array
var saved_filters:Array
var stored_keys:Array

func initialize(keys:Array, filters:Array=[]):
	stored_keys = keys
	dropdown.initialize("+", stored_keys)
	add_tab(stored_keys[0])

func save_filter(filter, idx:int=tabs.current_tab):
	saved_filters[idx] = filter.duplicate()

func add_tab(tab_key:String, filter={}):
	displayed_keys.append(tab_key)
	saved_filters.append(filter.duplicate())
	tabs.add_tab(tab_key)
	tabs.current_tab = tabs.get_tab_count()-1
	emit_signal("tab_changed", tab_key, filter)

func _on_Tabs_tab_changed(tab_idx):
	emit_signal("tab_changed", displayed_keys[tab_idx], saved_filters[tab_idx])

func _on_Tabs_reposition_active_tab_request(idx_to):
	var key = displayed_keys[tabs.current_tab]
	var filter = saved_filters[tabs.current_tab]
	displayed_keys.remove(tabs.current_tab)
	displayed_keys.insert(idx_to, key)
	saved_filters.remove(tabs.current_tab)
	saved_filters.insert(idx_to, filter)

func _on_Dropdown_item_selected(key):
	add_tab(key)

func _on_Tabs_tab_close(tab_idx):
	if (tabs.get_tab_count() > 1):
		displayed_keys.remove(tab_idx)
		saved_filters.remove(tab_idx)
		tabs.remove_tab(tab_idx)
		_on_Tabs_tab_changed(tabs.current_tab)
