extends Control

var toggled:bool = true;
@export var portrait:Sprite2D;
@export var textbox:Sprite2D;


func onBgColourInputChanged(color):
	$"../../../../BgColour".color = color;

func onPortraitWindowClose():
	$"../PortraitTab/LocalPorWindow".visible = false;
	SoundEffectManager.PlayCancel();
func onPortraitWindowOpen():
	$PortraitWindow.visible = true;
	SoundEffectManager.PlayAccept();
	
func onLocalPortraitWindowClose():
	$"../PortraitTab/LocalPorWindow".visible = false;
	SoundEffectManager.PlayAccept();
func onLocalPortraitWindowOpen():
	$"../PortraitTab/LocalPorWindow".visible = true;
	SoundEffectManager.PlayCancel();

func onCollabPortraitWindowClose():
	$"../PortraitTab/CollabPorWindow".visible = false;
	SoundEffectManager.PlayAccept();
func onCollabPortraitWindowOpen():
	$"../PortraitTab/CollabPorWindow".visible = true;
	SoundEffectManager.PlayCancel();

	
func onBoxSkinWindowClose():
	$BoxSkinWindow.visible = false;
	SoundEffectManager.PlayCancel();
	
func onBoxSkinWindowOpen():
	$BoxSkinWindow.visible = true;
	SoundEffectManager.PlayAccept();

func on_portrait_flip():
	if $PortraitFlip.button_pressed:
		$"../../../../PMD_Main/Portrait/Icon".scale.x = -1;
		SoundEffectManager.PlayCheckboxOn()
	else:
		$"../../../../PMD_Main/Portrait/Icon".scale.x = 1;
		SoundEffectManager.PlayCheckboxOff()
		

func _on_custom_background_btn_pressed():
	SoundEffectManager.PlayFolder()
	$BGImageOpener.popup_centered()  # Opens the dialog
	

func _on_upload_image_file_selected(path):
	var image_path = path
	var image = Image.new()
	image.load(image_path)
	image.resize(256, 192, Image.INTERPOLATE_NEAREST)
	
	var image_texture = ImageTexture.new()
	image_texture.set_image(image)
	
	$"../../../../BgColour/ImageBg".texture = image_texture
	SoundEffectManager.PlayBGImport()

func _on_portrait_hide_pressed():
	portrait.visible = !$PortraitHide.button_pressed;
	
	if($PortraitHide.button_pressed):
		SoundEffectManager.PlayCheckboxOn()
	else:
		SoundEffectManager.PlayCheckboxOff()
		


func _on_portrait_left_pressed():
	portrait.set_position(Vector2(108,276))

func _on_portrait_right_pressed():
	portrait.set_position(Vector2(660,276))



func _on_bg_reload_pressed():
	$"../../../../BgColour/ImageBg".texture = null
	SoundEffectManager.PlayRefresh()
	$"../../../../BgColour".color = Color.html("#4c4c4c");
	$BgColour.color = Color.html("#4c4c4c");


func _on_alignment_selected(index):
	SoundEffectManager.PlayChooseDropdown()
	match  index:
		0:
			portrait.set_position(Vector2(108,276))
		1:
			portrait.set_position(Vector2(660,276))
		2:
			portrait.set_position(Vector2(384,276))
