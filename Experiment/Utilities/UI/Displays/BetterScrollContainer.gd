extends ScrollContainer

export (bool) var horizontal_space_reserved = true
export (bool) var vertical_space_reserved = true

signal h_scroll_toggled
signal v_scroll_toggled

var h_scroll_visible = false
var v_scroll_visible = false

func _ready():
	var h_scroll = get_h_scrollbar()
	var v_scroll = get_v_scrollbar()
	var content = get_child(2)
	var ssx = v_scroll.rect_size.x if scroll_vertical_enabled else 0
	var ssy = h_scroll.rect_size.y if scroll_horizontal_enabled else 0
	var scroll_size = Vector2(ssx, ssy)
	content.initialize(scroll_size)

func _process(_delta):
	
	var hsv = get_h_scrollbar().visible
	if h_scroll_visible != hsv:
		h_scroll_visible = hsv
		emit_signal("h_scroll_toggled", hsv)
	
	var vsv = get_v_scrollbar().visible
	if v_scroll_visible != vsv:
		v_scroll_visible = vsv
		emit_signal("v_scroll_toggled", vsv)
