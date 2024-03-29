extends VFixedContainer

class_name DisplayList

export (bool) var horizontal = false
export (int) var boarder_space = 5

#var container:BoxContainer
var container:Container

var vBoxType = VShrinkBoxContainer
var hBoxType = HShrinkBoxContainer
#var vBoxType = VFlowContainer
#var hBoxType = HFlowContainer

var items=[]
var separators=[]

enum {SIGNAL, TARGET, METHOD, BINDS}

func _init():
	container = hBoxType.new() if horizontal else vBoxType.new()
	container.name = "BoxContainer"
	container.size_flags_horizontal = SIZE_EXPAND_FILL
	container.size_flags_vertical = SIZE_FILL
	add_child(container)

func clear_items():
	for item in items:
		item.name = "X"
		item.visible = false
		item.queue_free()
	items.clear()
	for separator in separators:
		separator.visible = false
		separator.queue_free()
	separators.clear()

func add_items(names:Array, valuesets:Array, optionsets:Array, scene, connections=[]):
	for i in range(0, names.size()):
		add_item(names[i], valuesets[i], optionsets[i], scene, connections)
		add_separator()

func add_item(item_name:String, values, options, scene:PackedScene, connections=[]):
	var item = scene.instance()
	item.initialize(item_name, values, options[item_name])
	items.append(item)
	container.add_child(item)
	for connection in connections:
		connect_item(item, connection)

func connect_item(item, connection:Array):
	if connection.size() >= 4:
		item.connect(connection[SIGNAL], connection[TARGET], connection[METHOD], connection[BINDS])
	else:
		item.connect(connection[SIGNAL], connection[TARGET], connection[METHOD])

func add_separator():
	var separator:HSeparator = HSeparator.new()
	separators.append(separator)
	container.add_child(separator)
