extends Control

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

func _on_fullscreen_butt_toggled(toggled_on):
	if toggled_on == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		print(DisplayServer.window_get_mode()) 
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		print(DisplayServer.window_get_mode()) 

# ------
# PAGE CODE
# ------
var CurPage = 1

func UpdatePage():
	# set pages visible depending on page
	$SettingsPanel/Page1.set_visible(CurPage == 1);
	$SettingsPanel/Page2.set_visible(CurPage == 2);
	
	# switch / match function :D
	match (CurPage):
			1:
				$Header.text = "WINDOW";
			2:
				$Header.text = "EXPORT";

func on_left_pressed():
	if CurPage == 1:
		CurPage = 1
	else:
		CurPage -= 1
	print(CurPage)
	UpdatePage()


func on_right_pressed():
	if CurPage == 3:
		CurPage = 3
	else:
		CurPage += 1
	$Header.text = "PAGE " + str(CurPage)
	print(CurPage)
	UpdatePage()


