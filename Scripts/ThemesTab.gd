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
	if PmdCollabDownloader.is_installed():
		$"../PortraitTab/CollabPorWindow".visible = true;
		SoundEffectManager.PlayCancel();
	else:
		$"../../../../DownloadScreen".visible = true;
		SoundEffectManager.PlayAccept();

	
func onBoxSkinWindowClose():
	$BoxSkinWindow.visible = false;
	SoundEffectManager.PlayCancel();

	
func onBoxSkinWindowOpen():
	$BoxSkinWindow.visible = true;
	SoundEffectManager.PlayAccept();

func on_portrait_flip():
	var icon_node = $"../../../../PMD_Main/Portrait/Icon"
	
	if $PortraitFlip.button_pressed:
		icon_node.scale.x = -1;
		SoundEffectManager.PlayCheckboxOn()
	else:
		icon_node.scale.x = 1;
		SoundEffectManager.PlayCheckboxOff()
	
	var source = icon_node.get_meta("last_source", "")
	
	if source == "collab":
		var collab_window = get_node_or_null("CollabPorWindow")
		if not collab_window:
			collab_window = get_node_or_null("../PortraitTab/CollabPorWindow")
		if collab_window:
			collab_window.update_emotion_options(false, true)
	elif source == "local":
		var local_window = get_node_or_null("LocalPorWindow")
		if not local_window:
			local_window = get_node_or_null("../PortraitTab/LocalPorWindow")
		if local_window:
			local_window.loadIconLocal()
		

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
	
	$DefaultBGs.selected = 0
	$"../../../../BgColour/PMD_QuizBG".visible = false
	$"../../../../BgColour/AnimatedBackground".visible = false

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
	$DefaultBGs.selected = 0
	$"../../../../BgColour/PMD_QuizBG".visible = false
	$"../../../../BgColour/AnimatedBackground".visible = false


func _on_alignment_selected(index):
	SoundEffectManager.PlayChooseDropdown()
	match  index:
		0:
			portrait.set_position(Vector2(108,276))
		1:
			portrait.set_position(Vector2(660,276))
		2:
			portrait.set_position(Vector2(384,276))


func on_defaultbg_change(index):
	if index == 0:
		$"../../../../BgColour/ImageBg".texture = null
	else:
		$"../../../../BgColour/ImageBg".texture = $DefaultBGs.get_item_icon(index)
	if index == 17:
		$"../../../../BgColour/PMD_QuizBG".visible = true
		$"../../../../BgColour/ImageBg".texture = null
		$"../../../../BgColour/AnimatedBackground".stop()
		$"../../../../BgColour/AnimatedBackground".visible = false
	elif index == 18:
		$"../../../../BgColour/AnimatedBackground".visible = true
		$"../../../../BgColour/AnimatedBackground".play("V26P09A")
	elif index == 19:
		$"../../../../BgColour/AnimatedBackground".visible = true
		$"../../../../BgColour/AnimatedBackground".play("Fogbound_Lake")
	elif index == 20:
		$"../../../../BgColour/AnimatedBackground".visible = true
		$"../../../../BgColour/AnimatedBackground".play("Sea_Day")
	elif index == 21:
		$"../../../../BgColour/AnimatedBackground".visible = true
		$"../../../../BgColour/AnimatedBackground".play("Sea_Night")
	elif index == 23:
		$"../../../../BgColour/AnimatedBackground".visible = true
		$"../../../../BgColour/AnimatedBackground".play("Beach_Sunset")
	elif index == 24:
		$"../../../../BgColour/AnimatedBackground".visible = true
		$"../../../../BgColour/AnimatedBackground".play("beach_cavemouth")
	elif index == 25:
		$"../../../../BgColour/AnimatedBackground".visible = true
		$"../../../../BgColour/AnimatedBackground".play("time_travel")
	else:
		$"../../../../BgColour/PMD_QuizBG".visible = false
		$"../../../../BgColour/AnimatedBackground".visible = false
	SoundEffectManager.PlayBGImport()


func _on_boxarrow_toggled(toggled_on):
	if toggled_on:
		$"../../../../PMD_Main/Textbox/TextArrow".visible = true
		SoundEffectManager.PlayCheckboxOn()
	else:
		$"../../../../PMD_Main/Textbox/TextArrow".visible = false
		SoundEffectManager.PlayCheckboxOff()

func _on_textbox_hidden(toggled_on):
	if toggled_on:
		$"../../../../PMD_Main/Textbox".visible = false
		SoundEffectManager.PlayCheckboxOn()
	else:
		$"../../../../PMD_Main/Textbox".visible = true
		SoundEffectManager.PlayCheckboxOff()


func _on_pmd_coll_download_btn_pressed():
	SoundEffectManager.PlayFolder()
	
	$"../../../../DownloadScreen".visible = true
