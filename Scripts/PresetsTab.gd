extends Control

@export var dialogTab:Control;
@export var skinWindow:Control;
@export var portraitMenu:Control;

@export var localFolderDropdownLocal:OptionButton;
@export var localEmotionDropdownLocal:OptionButton;

@export var hidePortraitToggle:CheckBox;
@export var flipPortraitButton:CheckBox;
@export var portrait:Sprite2D;

@export var testPreset:Preset;

func _ready():
	pass
	#LoadPreset(testPreset)
	
func LoadPreset(preset:Preset):
	# TEXT STUFF
	# dialogTab.sentence = preset.text;
	dialogTab.prefix = preset.prefix;
	dialogTab.prefixColour = preset.prefixColor;
	
	dialogTab.updateHUD();
	
	# SKIN STUFF
	var skinDropdownIndex = get_index_by_name(skinWindow.skinDropdown, preset.skinName);
	skinWindow.OnSkinDropdownItemSelected(skinDropdownIndex)
	skinWindow.skinDropdown.selected = skinDropdownIndex;
	match preset.skinGender:
		1:
			skinWindow.OnMaleTypePressed();
		2: 
			skinWindow.OnFemaleTypePressed();
		3:
			skinWindow.OnNonBinaryTypePressed();
	
	# PORTRAIT STUFF
	if(preset.pmdCollabPortraitURL != null):
		portraitMenu.loadIconCollabFromURL(preset.pmdCollabPortraitURL);
	else:
		localFolderDropdownLocal.selected = get_index_by_name(localFolderDropdownLocal, preset.customPortraitName)
		localEmotionDropdownLocal.selected = get_index_by_name(localEmotionDropdownLocal, preset.customPortraitEmotion)
		
		portraitMenu.loadIconLocal();
	
	portrait.position = preset.iconPosition
	flipPortraitButton.button_pressed = preset.flipPortrait;
	flipPortraitButton.pressed.emit()
	
	hidePortraitToggle.button_pressed = preset.hidePortrait;
	hidePortraitToggle.pressed.emit()
	

func get_index_by_name(dropdown: OptionButton, target_name: String) -> int:
	for i in range(dropdown.get_item_count()):
		if dropdown.get_item_text(i) == target_name:
			return i
	return -1  # Name not found

