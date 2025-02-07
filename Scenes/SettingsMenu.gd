extends Control

func _on_settings_pressed():
	if $SettingsMenu.visible == false:
		$SettingsMenu.visible = true;
	else:
		$SettingsMenu.visible = false;

func resize_window(new_width: int, new_height: int):
	DisplayServer.window_set_size(Vector2i(new_width, new_height))
	
func _on_window_size_item_selected(index):
	match index:
			0:
				resize_window(768, 576);
			1:
				resize_window(1024, 768);
			2:
				resize_window(1280, 960);
