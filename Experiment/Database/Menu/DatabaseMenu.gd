extends ViewportContainer

onready var tabs:TabsPanel = $VBoxContainer/Tabs
onready var options:OptionsPanel = $VBoxContainer/option_panel
onready var display:DisplayPanel = $VBoxContainer/display_panel

func _ready():
	tabs.initialize(options)
	options.initialize(display)

#func _process(delta):
#	var window_size = OS.window_size
#	ratio = window_size.x / window_size.y

func update_menu():
	display.update_display()

func get_reqs():
	return options.reqs
