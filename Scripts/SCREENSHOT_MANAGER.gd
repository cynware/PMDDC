extends Node


@onready var saveWindow:FileDialog = $SaveWindow;

@export var transparentBackgroundToggle:CheckBox;
@export var resolutionMultiplierDropdown:OptionButton;

# so we can hide them for the screenshot
@export var background:ColorRect;
@export var debugMenu:Node2D;
@export var settingsButton:TextureButton;
 
#@export var debugShit:ColorRect;

var capture = null;

func _ready():
	get_viewport().transparent_bg = true;	
	DisplayServer.window_set_min_size(Vector2(256, 192));
	
func _process(delta):
	#if Input.is_action_just_pressed("ResetWindowSize"):
		#get_window().size = Vector2(256, 192);
		#get_viewport().size = Vector2(256, 192);
		#get_window().mode = Window.MODE_WINDOWED;
		
	if Input.is_action_just_pressed("SCREENSHOT"):
		takeTransparentScreenshot();
		# capture = get_viewport().get_texture().get_image();
		

func takeTransparentScreenshot():
	background.visible = !$"../Settings/SettingsMenu/SettingsPanel/Page2/TransparentBackground".button_pressed;
	debugMenu.visible = false;
	settingsButton.visible = false;
	
	var viewport := get_viewport()	
	await RenderingServer.frame_post_draw
	
	var img = viewport.get_texture().get_image()
	var markiplier := int(resolutionMultiplierDropdown.selected)+1;
	img.resize(256 * markiplier, 192 * markiplier, Image.INTERPOLATE_NEAREST)
	capture = img;
	
	background.visible = true;
	debugMenu.visible = true;
	settingsButton.visible = true;
	
	saveWindow.visible = true;
	

func _on_save_window_file_selected(path):
	print(path);
	if capture != null:
		capture.save_png(path);

