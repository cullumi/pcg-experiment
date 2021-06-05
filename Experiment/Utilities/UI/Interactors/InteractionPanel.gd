extends PanelContainer

class_name InteractionPanel

onready var node_display:NodeDisplay = $VBoxContainer/DBNodeDisplay
onready var action_button:Button = $VBoxContainer/Button

var contents:Array = []
var node
var editing = false

func _ready():
	node_display.initialize(true)

func set_node(new_node):
	node = new_node
	node_display.set_node(new_node)

func toggle(show=null):
	if show == null:
		visible = not visible
	else:
		visible = show

func set_edit(edit):
	editing = edit
	if edit:
		action_button.text = "Save"
	else:
		action_button.text = "Add"
