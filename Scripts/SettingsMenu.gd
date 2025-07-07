extends Control

@export var arrowLeft:TextureButton;
@export var arrowRight:TextureButton;

var initialArrowLeftPos:Vector2;
var initialArrowRightPos:Vector2;

func _ready():
	initialArrowLeftPos = arrowLeft.position;
	initialArrowRightPos = arrowRight.position;

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
	
	var tween = get_tree().create_tween()
	tween.tween_property(arrowLeft, "position", initialArrowLeftPos + Vector2.LEFT *5, 0.1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC);
	await tween.finished
	var backTween = get_tree().create_tween()
	backTween.tween_property(arrowLeft, "position", initialArrowLeftPos, 0.25).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK);
	
	
	


func on_right_pressed():
	if CurPage == 3:
		CurPage = 3
	else:
		CurPage += 1
	$Header.text = "PAGE " + str(CurPage)
	print(CurPage)
	UpdatePage()
	
	var tween = get_tree().create_tween()
	tween.tween_property(arrowRight, "position", initialArrowRightPos + Vector2.RIGHT *5, 0.1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC);
	await tween.finished
	var backTween = get_tree().create_tween()
	backTween.tween_property(arrowRight, "position", initialArrowRightPos, 0.25).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK);
	
func _process(delta):
	if(Input.is_action_just_pressed("UI_RIGHT") && $".".visible):
		on_right_pressed()
	elif (Input.is_action_just_pressed("UI_LEFT") && $".".visible):
		on_left_pressed()

