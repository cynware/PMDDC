extends Control

@export_category("TAB ELEMENTS")
@export var presetDropdown:OptionButton;
@export var presetNameField:LineEdit;

@export_category("NEEDED FOR SAVE STUFF")
@export var dialogTab:Control;
@export var skinWindow:Control;
@export var portraitMenu:Control;

@export var localFolderDropdownLocal:OptionButton;
@export var localEmotionDropdownLocal:OptionButton;

@export var hidePortraitToggle:CheckBox;
@export var flipPortraitButton:CheckBox;
@export var portrait:Sprite2D;



func _ready():
	CheckAndCreatePresetFolder()
	RefreshDropdown()
	
func LoadPreset(preset:Preset):
	# TEXT STUFF
	# dialogTab.sentence = preset.text;
	dialogTab.prefix = preset.prefix;
	dialogTab.prefixColour = Color.html(preset.prefixColor);
	dialogTab.prefixColourPicker.color = dialogTab.prefixColour;
	dialogTab.prefixEdit.text = dialogTab.prefix;
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
	
	if(preset.pmdCollabPortraitURL != ""):
		portraitMenu.loadIconCollabFromURL(preset.pmdCollabPortraitURL);
	else:
		localFolderDropdownLocal.selected = get_index_by_name(localFolderDropdownLocal, preset.customPortraitName)
		localFolderDropdownLocal.item_selected.emit(localFolderDropdownLocal.selected)
		localEmotionDropdownLocal.selected = get_index_by_name(localEmotionDropdownLocal, preset.customPortraitEmotion)
		localEmotionDropdownLocal.item_selected.emit(localEmotionDropdownLocal.selected)
		
	
	portrait.position = preset.iconPosition
	flipPortraitButton.button_pressed = preset.flipPortrait;
	flipPortraitButton.pressed.emit()
	
	hidePortraitToggle.button_pressed = preset.hidePortrait;
	hidePortraitToggle.pressed.emit()
	

func CheckAndCreatePresetFolder():
	if (!DirAccess.dir_exists_absolute("user://Presets")):
		DirAccess.make_dir_absolute("user://Presets")
		print("MADE PORTRAITS FOLDER + TEMPLATES")
	else:
		print("PORTRAITS FOLDER ALREADY EXISTS")

func SaveCurrentStateAsPreset():
	CheckAndCreatePresetFolder()
	
	# CREATING THE PRESET RESOURCE
	var preset:Preset = Preset.new();
	
	preset.prefix = dialogTab.prefix;
	preset.prefixColor = dialogTab.prefixColour.to_html();
	preset.text = dialogTab.sentence;

	preset.skinGender = skinWindow.currentlySelectedGender;
	preset.skinName = skinWindow.skinDropdown.text;
	if(portraitMenu.curPmdCollabURL == ""):
		preset.customPortraitName = portraitMenu.localFolderDropdownLocal.text;
		preset.customPortraitEmotion = portraitMenu.localEmotionDropdownLocal.text;
	else:
		preset.pmdCollabPortraitURL = portraitMenu.curPmdCollabURL;
		
	
	preset.iconPosition = portrait.position;
	preset.flipPortrait = flipPortraitButton.button_pressed;
	preset.hidePortrait = hidePortraitToggle.button_pressed;
	
	var json = dict_to_json(preset);
	
	# Actually saving to file
	var savePath = "user://Presets/" + presetNameField.text + ".json";
	var file = FileAccess.open(savePath, FileAccess.WRITE);
	
	if file:
		file.store_string(json);
		file.close();
	else:
		print("Failed to write preset to file at path: " + savePath);
	
	RefreshDropdown()
	
func LoadPresetFromDropdown(index):
	var path = "user://Presets/" + presetDropdown.text;
	var file = FileAccess.open(path, FileAccess.READ)
	var content = file.get_as_text()
	file.close()

	var result = JSON.parse_string(content)
	if typeof(result) != TYPE_DICTIONARY:
		push_error("Failed to parse JSON")
		return null

	var data = result as Dictionary;
	var preset = Preset.new()
	
	preset.prefix = data.prefix;
	preset.prefixColor = data.prefixColor;
	preset.text = data.text;
	preset.skinName = data.skinName;
	preset.skinGender = data.skinGender;
	preset.pmdCollabPortraitURL = data.pmdCollabPortraitURL;
	preset.customPortraitName = data.customPortraitName;
	preset.customPortraitEmotion = data.customPortraitEmotion;
	preset.iconPosition = string_to_vector2(data.iconPosition)
	preset.flipPortrait = data.flipPortrait;
	preset.hidePortrait = data.hidePortrait;
	
	# Assign values from JSO
	
	LoadPreset(preset);
	
func RefreshDropdown():
	presetDropdown.clear();
		
	for preset in DirAccess.get_files_at("user://Presets"):
		presetDropdown.add_item(preset);
func get_index_by_name(dropdown: OptionButton, target_name: String) -> int:
	for i in range(dropdown.get_item_count()):
		if dropdown.get_item_text(i) == target_name:
			return i
	return -1  # Name not found
	
func resource_to_dict(res:Resource) -> Dictionary:
	var dict := {}
	
	for prop in res.get_property_list():
		var name = prop.name;
		dict[name] = res.get(name);
	
	return dict;

func dict_to_json(resource) -> String:
	var json_string = JSON.stringify(resource_to_dict(resource), "\t");
	return json_string;

func string_to_vector2(s: String) -> Vector2:
	s = s.strip_edges().replace("(", "").replace(")", "")
	var parts = s.split(",")
	if parts.size() == 2:
		return Vector2(parts[0].to_float(), parts[1].to_float())
	return Vector2.ZERO
	



func OnSavePresetPressed():
	SaveCurrentStateAsPreset()


func OnDeletePresetPressed():
	DirAccess.remove_absolute("user://Presets/" + presetDropdown.text);
	RefreshDropdown()
