extends VBoxContainer

export (bool) var no_duplicates = true

onready var name_label:Label = $Name
onready var tag_flowpanel:PanelContainer = $HBoxContainer/PanelContainer
onready var tag_flow:Container = $HBoxContainer/PanelContainer/TagFlow
onready var dropdown:Dropdown = $HBoxContainer/Dropdown

signal tag_selected
signal tags_changed
signal tag_registered
signal tag_deregistered

var tag_items:Array = []
var registered_tags:Array
var unregistered_tags:Array

var reg=[]
var unreg=[]

var initialized = false
var readied = false

func initialize(new_name:String, new_tags:Array, new_tag_options:Array=[]):
	name = new_name
	reg = new_tags
	unreg = new_tag_options
	if readied: populate()
	initialized = true

func _ready():
	if initialized: populate()
	readied = true

func populate():
	set_name(name)
	set_tag_options(unreg)
	register_tags(reg)

func set_name(new_name):
	name = new_name
	name_label.text = name

# Affect the options available in the dropdown for adding unregistered tag Strings

func set_tag_options(new_tag_options:Array=unregistered_tags):
	unregistered_tags = new_tag_options
	dropdown.visible = not unregistered_tags.empty()
	dropdown.initialize("+", new_tag_options)

func remove_tag_option(option:String):
	if (unregistered_tags.has(option)):
		unregistered_tags.erase(option)
		set_tag_options()

func add_tag_option(option:String):
	if (not unregistered_tags.has(option)):
		unregistered_tags.append(option)
		set_tag_options()

# The Process for adding new registered tag Strings

func register_tags(new_tags:Array):
	for tag in new_tags:
		register_tag(tag)

# Registering or Deregistering Tags

func add_tag_item(tag:String):
	
	var tagNameButton:Button = Button.new()
	tagNameButton.name = "TagName"
	tagNameButton.text = tag
# warning-ignore:return_value_discarded
	tagNameButton.connect("pressed", self, "_on_tagItem_pressed", [tag])
	
	var tagDeregButton:Button = Button.new()
	tagDeregButton.name = "Deregister"
	tagDeregButton.text = "X"
# warning-ignore:return_value_discarded
	tagDeregButton.connect("pressed", self, "_on_deregisterTag_pressed", [tag])
	
	var item:HBoxContainer = HBoxContainer.new()
	item.name = tag
	item.add_child(tagNameButton)
	item.add_child(tagDeregButton)
	
	tag_items.append(item)
	tag_flow.add_child(item)

func adjust_columns():
	var max_count = INF
	var width:float = 0
	var count:int = 0
	var row:int = 0
	var idx:int = 0
	while idx < tag_items.size():
		var item = tag_items[idx]
		count += 1
		width += item.rect_width
		if width > tag_flowpanel.rect_width:
			max_count = count-1
#			tag_flow.columns = count-1
		if count >= max_count:
			width = 0
			count = 0
			continue
		width += tag_flow.hseparation

func delete_tag_item(index):
	var item = tag_items[index]
	tag_items.remove(index)
	tag_flow.remove_child(item)
	var tagNameButton = item.get_node("TagName")
	tagNameButton.disconnect("pressed", self, "_on_tagItem_pressed")
	item.queue_free()

func register_tag(tag:String):
	if (registered_tags.has(tag)): return
	remove_tag_option(tag)
	registered_tags.append(tag)
	add_tag_item(tag)
#	print("Tag Item Registered: ", tag)

func deregister_tag(tag:String):
	if (not registered_tags.has(tag)): return
	add_tag_option(tag)
	var index = registered_tags.find(tag)
	registered_tags.remove(index)
	delete_tag_item(index)
#	print("Tag Item DeRegistered: ", tag)

# Signal emission

func _on_tagItem_pressed(value):
	emit_signal("tag_selected", name, value)

func _on_Dropdown_item_selected(tag:String):
	register_tag(tag)
	emit_signal("tag_registered", name, tag)
	emit_signal("tags_changed", name)

func _on_deregisterTag_pressed(tag:String):
	deregister_tag(tag)
	emit_signal("tag_deregistered", name, tag)
	emit_signal("tags_changed", name)
