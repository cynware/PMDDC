extends Control

@export var arrowLeft:TextureButton;
@export var arrowRight:TextureButton;

var initialArrowLeftPos:Vector2;
var initialArrowRightPos:Vector2;

func _ready():
	$BuildNum.text = "v" + ProjectSettings.get_setting("application/config/version");
	initialArrowLeftPos = arrowLeft.position;
	initialArrowRightPos = arrowRight.position;
	
	$SettingsPanel/Page3/Vol_MASTER/Master_Slider.value = Preferences.audio_masterVolume
	$SettingsPanel/Page3/Vol_MUSIC/Music_Slider.value = Preferences.audio_musicVolume
	$SettingsPanel/Page3/Vol_SFX/SFX_Slider.value = Preferences.audio_sfxVolume

func _on_master_sbox_value_changed(value):
	_on_master_slider_value_changed(value)
	$SettingsPanel/Page3/Vol_MASTER/Master_Slider.value = $SettingsPanel/Page3/Vol_MASTER/Master_SBOX.value
	Preferences.audio_masterVolume = $SettingsPanel/Page3/Vol_MASTER/Master_Slider.value;

func _on_music_sbox_value_changed(value):
	_on_MusicSlider_value_changed(value)
	$SettingsPanel/Page3/Vol_MUSIC/Music_Slider.value = $SettingsPanel/Page3/Vol_MUSIC/Music_SBOX.value
	Preferences.audio_musicVolume = $SettingsPanel/Page3/Vol_MUSIC/Music_Slider.value;
	

func _on_sfx_sbox_value_changed(value):
	_on_SFXSlider_value_changed(value)
	$SettingsPanel/Page3/Vol_SFX/SFX_Slider.value = $SettingsPanel/Page3/Vol_SFX/SFX_SBOX.value
	Preferences.audio_sfxVolume = $SettingsPanel/Page3/Vol_SFX/SFX_Slider.value;
	

func _on_master_slider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)
	print(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")))
	if AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")) <= 0 and AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")) >= -6:
		$SettingsPanel/Page3/Vol_MASTER.texture_normal = load("res://Assets/Images/speaker_3.png")
	else: if AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")) <= -6 and AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")) >= -20:
		$SettingsPanel/Page3/Vol_MASTER.texture_normal = load("res://Assets/Images/speaker_2.png")
	else: if AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")) <= -20 and AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")) >= -30:
		$SettingsPanel/Page3/Vol_MASTER.texture_normal = load("res://Assets/Images/speaker_1.png")
	if AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")) == -30:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), -80)
		print(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")))
		
	$SettingsPanel/Page3/Vol_MASTER/Master_SBOX.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))
	

func on_mute_master(toggled_on):
	$SettingsPanel/Page3/Vol_MASTER.texture_normal = load("res://Assets/Images/speaker_0.png")
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), -80)

func _on_MusicSlider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), value)
	print(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")))
	if AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")) <= 0 and AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")) >= -6:
		$SettingsPanel/Page3/Vol_MUSIC.texture_normal = load("res://Assets/Images/speaker_3.png")
	else: if AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")) <= -6 and AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")) >= -20:
		$SettingsPanel/Page3/Vol_MUSIC.texture_normal = load("res://Assets/Images/speaker_2.png")
	else: if AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")) <= -20 and AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")) >= -30:
		$SettingsPanel/Page3/Vol_MUSIC.texture_normal = load("res://Assets/Images/speaker_1.png")
	if AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")) == -30:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), -80)
		print(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")))
		
	$SettingsPanel/Page3/Vol_MUSIC/Music_SBOX.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music"))

func on_mute_music(toggled_on):
	SoundEffectManager.PlayMute()
	$SettingsPanel/Page3/Vol_MUSIC.texture_normal = load("res://Assets/Images/speaker_0.png")
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), -80)

func _on_SFXSlider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Sound"), value)
	print(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Sound")))
	if AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Sound")) <= 0 and AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Sound")) >= -6:
		$SettingsPanel/Page3/Vol_SFX.texture_normal = load("res://Assets/Images/speaker_3.png")
	else: if AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Sound")) <= -6 and AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Sound")) >= -20:
		$SettingsPanel/Page3/Vol_SFX.texture_normal = load("res://Assets/Images/speaker_2.png")
	else: if AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Sound")) <= -20 and AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Sound")) >= -30:
		$SettingsPanel/Page3/Vol_SFX.texture_normal = load("res://Assets/Images/speaker_1.png")
	if AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Sound")) == -30:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Sound"), -80)
		print(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Sound")))
		
	$SettingsPanel/Page3/Vol_SFX/SFX_SBOX.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Sound"))

func on_mute_SFX(toggled_on):
	SoundEffectManager.PlayMute()
	$SettingsPanel/Page3/Vol_SFX.texture_normal = load("res://Assets/Images/speaker_0.png")
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Sound"), -80)

# stop audio changeing

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
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		print(DisplayServer.window_get_mode()) 
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
		_on_window_size_item_selected(0)
		print(DisplayServer.window_get_mode()) 

# ------
# PAGE CODE
# ------
var CurPage = 1

func UpdatePage():
	# set pages visible depending on page
	$SettingsPanel/Page1.set_visible(CurPage == 1);
	$SettingsPanel/Page2.set_visible(CurPage == 2);
	$SettingsPanel/Page3.set_visible(CurPage == 3);
	
	# switch / match function :D
	match (CurPage):
			1:
				$Header.text = "WINDOW";
			2:
				$Header.text = "EXPORT";
			3:
				$Header.text = "AUDIO";

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




func _on_visibility_changed():
	if(!visible):
		Preferences.SavePreferences()
