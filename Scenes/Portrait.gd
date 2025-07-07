extends Sprite2D

var dragging = false
var offsetty = Vector2(0,0)

var snap = 3

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if dragging:
		var newPos = get_global_mouse_position() - offsetty
		position = Vector2(snapped(newPos.x,snap),snapped(newPos.y,snap))
		
	var pos = position
	var screen_size = get_viewport_rect().size
	var portrait_size = $".".get_texture().get_size() / 2
	
	pos.x = clamp(pos.x, portrait_size.y, screen_size.x - portrait_size.x)
	pos.y = clamp(pos.y, portrait_size.y, screen_size.y - portrait_size .y)
	position = pos


func _on_button_button_down():
	dragging = true
	offsetty = get_global_mouse_position() - global_position

func _on_button_button_up():
	dragging = false
