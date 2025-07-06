extends Control

var toggled:bool = true;
@export var portrait:Sprite2D;
@export var textbox:Sprite2D;


func onBgColourInputChanged(color):
	$"../../../../BgColour".color = color;


func _on_change_blue_pressed():
	textbox.texture = load("res://PmdThemes/eos/eosBox_M.png");
	portrait.texture = load("res://PmdThemes/eos/eosIcon_M.png");


func _on_change_pink_pressed():
	textbox.texture = load("res://PmdThemes/eos/eosBox_F.png");
	portrait.texture = load("res://PmdThemes/eos/eosIcon_F.png");


func _on_change_green_pressed():
	textbox.texture = load("res://PmdThemes/eos/eosBox_NB.png");
	portrait.texture = load("res://PmdThemes/eos/eosIcon_NB.png");

func onPortraitWindowClose():
	$PortraitWindow.visible = false;
	$ClickSFX.play();

func onPortraitWindowOpen():
	$PortraitWindow.visible = true;
	$ClickSFX.play();
	
func onBoxSkinWindowClose():
	$BoxSkinWindow.visible = false;
	$ClickSFX.play()

func onBoxSkinWindowOpen():
	$BoxSkinWindow.visible = true;
	$ClickSFX.play();

func on_portrait_flip():
	if $PortraitFlip.button_pressed:
		$"../../../../PMD_Main/Portrait/Icon".scale.x = -1;
	else:
		$"../../../../PMD_Main/Portrait/Icon".scale.x = 1;

func _on_custom_background_btn_pressed():
	$BGImageOpener.popup_centered()  # Opens the dialog


func _on_upload_image_file_selected(path):
	var image_path = path
	var image = Image.new()
	image.load(image_path)
	image.resize(256, 192, Image.INTERPOLATE_NEAREST)
	
	var image_texture = ImageTexture.new()
	image_texture.set_image(image)
	
	$"../../../../BgColour/ImageBg".texture = image_texture

func _on_portrait_hide_pressed():
	portrait.visible = !$PortraitHide.button_pressed;


func _on_portrait_left_pressed():
	portrait.set_position(Vector2(108,276))

func _on_portrait_right_pressed():
	portrait.set_position(Vector2(660,276))

