extends Node


@onready var saveWindow:FileDialog = $SaveWindow;
#@export var debugShit:ColorRect;

var capture = null;

func _ready():
	DisplayServer.window_set_min_size(Vector2(256, 192));
	
func _process(delta):
	#if Input.is_action_just_pressed("ResetWindowSize"):
		#get_window().size = Vector2(256, 192);
		#get_viewport().size = Vector2(256, 192);
		#get_window().mode = Window.MODE_WINDOWED;
		
	if Input.is_action_just_pressed("SCREENSHOT"):
		capture = get_viewport().get_texture().get_image();
		saveWindow.visible = true;
		


func _on_save_window_file_selected(path):
	print(path);
	if capture != null:
		capture.save_png(path);

