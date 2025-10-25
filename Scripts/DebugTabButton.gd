extends Button

func _on_button_down():
	$"..".position.y = 11
	$"../../TAB_DISPLAYNAME".position.y = 17

func _on_button_up():
	$"..".position.y = 8
	$"../../TAB_DISPLAYNAME".position.y = 14
