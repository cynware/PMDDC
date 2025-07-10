extends TextureButton


# Called when the node enters the scene tree for the first time.
func _ready():
	$GearSprite.play("Spin") #Made animation play to fix bug where it won't play when first pressed


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if Input.is_action_just_pressed("Settings_Shortcut"):
		if get_node("SettingsMenu").visible == false:
			_on_settings_pressed()
		else:
			_on_close_btn_pressed()

func _on_settings_pressed():
	get_node("SettingsMenu").visible = true
	$GearSprite.play("Spin")
	var sound_player = $GearSprite/SettingSound
	sound_player.pitch_scale = randf_range(0.8, 0.95)
	sound_player.play()
	
func _on_close_btn_pressed():
	get_node("SettingsMenu").visible = false
