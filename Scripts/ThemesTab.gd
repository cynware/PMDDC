extends Control

var toggled:bool = true;
@export var portrait:Sprite2D;
@export var textbox:Sprite2D;


func onBgColourInputChanged(color):
	$"../../../../BgColour".color = color;

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
	$PortraitWindow/FolderBTN/FolderBTNSound.play()
	$BGImageOpener.popup_centered()  # Opens the dialog
	

func _on_upload_image_file_selected(path):
	var image_path = path
	var image = Image.new()
	image.load(image_path)
	image.resize(256, 192, Image.INTERPOLATE_NEAREST)
	
	var image_texture = ImageTexture.new()
	image_texture.set_image(image)
	
	$"../../../../BgColour/ImageBg".texture = image_texture
	$CustomBackgroundBTN/BGImport.play()

func _on_portrait_hide_pressed():
	portrait.visible = !$PortraitHide.button_pressed;


func _on_portrait_left_pressed():
	portrait.set_position(Vector2(108,276))

func _on_portrait_right_pressed():
	portrait.set_position(Vector2(660,276))



func _on_bg_reload_pressed():
	$"../../../../BgColour/ImageBg".texture = null
	$PortraitWindow/RefreshBTN/RefreshBTNSound.play()
	$"../../../../BgColour".color = Color.html("#4c4c4c");
	$BgColour.color = Color.html("#4c4c4c");
