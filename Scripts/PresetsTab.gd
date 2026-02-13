extends Control

@export var noticeScreen:Control;

@export_category("TAB ELEMENTS")
@export var presetDropdown:OptionButton;
@export var presetNameField:LineEdit;

@export_category("NEEDED FOR SAVE STUFF")
@export var dialogTab:Control;
@export var skinWindow:Control;
@export var portraitMenu:Control;
@export var collabPortraitMenu:Control;

@export var localFolderDropdownLocal:OptionButton;
@export var localEmotionDropdownLocal:OptionButton;

@export var hidePortraitToggle:CheckBox;
@export var flipPortraitButton:CheckBox;
@export var portrait:Sprite2D;



func _ready():
	CheckAndCreatePresetFolder()
	RefreshDropdown()
	if presetDropdown:
		presetDropdown.add_theme_constant_override("icon_max_width", 16)
	
func LoadPreset(preset:Preset):
	# TEXT STUFF
	# dialogTab.sentence = preset.text;
	dialogTab.prefix = preset.prefix;
	dialogTab.prefixEnabled.button_pressed = preset.prefixEnabled;
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
	
	if preset.lastSource == "collab":
		var dex_input = collabPortraitMenu.get_node("DexNum")
		var form_dropdown = collabPortraitMenu.get_node("Form_Collab")
		var emotion_dropdown = collabPortraitMenu.get_node("Emotion_Collab")
		
		dex_input.text = preset.collabDexId
		collabPortraitMenu.populate_collab_options(false) # false to not play sound
		
		form_dropdown.selected = get_index_by_name(form_dropdown, preset.collabForm)
		collabPortraitMenu._on_form_collab_item_selected(form_dropdown.selected)
		
		emotion_dropdown.selected = get_index_by_name(emotion_dropdown, preset.collabEmotion)
		collabPortraitMenu._on_emotion_collab_item_selected(emotion_dropdown.selected)
	else:
		localFolderDropdownLocal.selected = get_index_by_name(localFolderDropdownLocal, preset.customPortraitName)
		localFolderDropdownLocal.item_selected.emit(localFolderDropdownLocal.selected)
		localEmotionDropdownLocal.selected = get_index_by_name(localEmotionDropdownLocal, preset.customPortraitEmotion.get_basename())
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
	preset.prefixEnabled = dialogTab.prefixEnabled.button_pressed;
	preset.prefixColor = dialogTab.prefixColour.to_html();
	preset.text = dialogTab.sentence;

	preset.skinGender = skinWindow.currentlySelectedGender;
	preset.skinName = skinWindow.skinDropdown.text;
	
	preset.lastSource = portrait.get_node("Icon").get_meta("last_source", "local")
	
	if preset.lastSource == "collab":
		preset.collabDexId = collabPortraitMenu.get_node("DexNum").text
		preset.collabForm = collabPortraitMenu.get_node("Form_Collab").text
		preset.collabEmotion = collabPortraitMenu.get_node("Emotion_Collab").text
	else:
		preset.customPortraitName = portraitMenu.localFolderDropdownLocal.text;
		preset.customPortraitEmotion = portraitMenu.emotions[localEmotionDropdownLocal.get_selected_id()];
		
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
		var errorText = "Whoo-hoops! You have to put your CD back in your computer!\n\nFailed to save the preset. :(\nPlease try again.\n\nIf this problem doesn't go away, make sure you aren't using any forbidden characters, or you have enough available storage."
		noticeScreen.ShowNoticeScreen(errorText);
		print("Failed to write preset to file at path: " + savePath);
	
	RefreshDropdown()

func IsPresetValid(preset:Preset) -> bool:
	var errorHeader = "Whoo-hoops! You have to put your CD back in your computer!\n\nFailed to load the preset. :(\n\n";
	
	if(preset.lastSource == "collab"):
		if !collabPortraitMenu.pokedex.has(preset.collabDexId):
			var errorText = errorHeader + "The preset mentions a collab portrait (ID: " + preset.collabDexId + ") that isn't found in your local database.";
			noticeScreen.ShowNoticeScreen(errorText);
			return false;
		
		# Validate collab file existence
		var pkmn = collabPortraitMenu.pokedex[preset.collabDexId]
		var relative_path = ""
		if pkmn.forms.has(preset.collabForm):
			relative_path = pkmn.forms[preset.collabForm].relative_path
		
		var img_path = "user://PMDCollab/portrait/" + preset.collabDexId + "/"
		if relative_path != "":
			img_path = img_path.path_join(relative_path) + "/"
		img_path += preset.collabEmotion + ".png"
		
		if !FileAccess.file_exists(img_path):
			var errorText = errorHeader + "The preset mentions a collab emotion called \"" + preset.collabEmotion + "\" for " + pkmn.name + " (" + preset.collabForm + ") that doesn't exist locally.";
			noticeScreen.ShowNoticeScreen(errorText);
			return false;
		return true;
	
	# Local Portrait Validation
	if(!DirAccess.dir_exists_absolute("user://Portraits/" + preset.customPortraitName)):
		var errorText = errorHeader + "The preset mentions a custom portrait collection called \"" + preset.customPortraitName + "\" that doesn't exist.";
		noticeScreen.ShowNoticeScreen(errorText);
		return false;
	
	if(!FileAccess.file_exists("user://Portraits/" + preset.customPortraitName + "/" + preset.customPortraitEmotion)):
		var errorText = errorHeader + "The preset mentions a custom emotion called \"" + preset.customPortraitEmotion + "\" belonging to the \"" + preset.customPortraitName + "\" portrait collection that doesn't exist.";
		noticeScreen.ShowNoticeScreen(errorText);
		return false;
	
	# Skin Validation
	var is_internal = false
	var localSkins = DirAccess.get_directories_at("res://PmdSkins");
	if localSkins.has(preset.skinName):
		is_internal = true
	
	if !is_internal and !DirAccess.dir_exists_absolute("user://BoxSkins/" + preset.skinName):
		var errorText = errorHeader + "The preset mentions a custom box skin collection called \"" + preset.skinName + "\" that doesn't exist.";
		noticeScreen.ShowNoticeScreen(errorText);
		return false;
	
	var genderFolderName = "";
	match preset.skinGender:
		1: genderFolderName = "Male"
		2: genderFolderName = "Female"
		3: genderFolderName = "NonBinary"
	
	var skin_base_path = "res://PmdSkins/" if is_internal else "user://BoxSkins/"
	if(!DirAccess.dir_exists_absolute(skin_base_path + preset.skinName + "/" + genderFolderName)):
		var errorText = errorHeader + "Couldn't locate the gender folder \"" + genderFolderName + "\" in the skin \"" + preset.skinName + "\".";
		noticeScreen.ShowNoticeScreen(errorText);
		return false;
			
	return true;
func LoadPresetFromDropdown(index):
	
	var path = "user://Presets/" + presetDropdown.text + ".json";
	var file = FileAccess.open(path, FileAccess.READ)
	var content = file.get_as_text()
	file.close()

	var result = JSON.parse_string(content)
	if typeof(result) != TYPE_DICTIONARY:
		var errorText = "Whoo-hoops! You have to put your CD back in your computer!\n\nFailed to parse the " + presetDropdown.text + " preset. :(\n\nIf this keeps happening, the preset may be corrupted or has incorrect formatting."
		noticeScreen.ShowNoticeScreen(errorText);
		push_error("Failed to parse JSON")
		return null

	var data = result as Dictionary;
	var preset = Preset.new()
	
	preset.prefix = data.prefix;
	preset.prefixEnabled = data.get("prefixEnabled", true);
	preset.prefixColor = data.prefixColor;
	preset.text = data.text;
	preset.skinName = data.skinName;
	preset.skinGender = data.skinGender;
	
	preset.lastSource = data.get("lastSource", "local")
	preset.collabDexId = data.get("collabDexId", "")
	preset.collabForm = data.get("collabForm", "")
	preset.collabEmotion = data.get("collabEmotion", "")
	
	preset.customPortraitName = data.customPortraitName;
	preset.customPortraitEmotion = data.customPortraitEmotion;
	preset.iconPosition = string_to_vector2(data.iconPosition)
	preset.flipPortrait = data.flipPortrait;
	preset.hidePortrait = data.hidePortrait;
	
	# Assign values from JSO
	if(!IsPresetValid(preset)): 
		return;
	
	LoadPreset(preset);
	set_dropdown_icon_resized(presetDropdown, index)
	
func RefreshDropdown():
	presetDropdown.clear();
	
	var files = DirAccess.get_files_at("user://Presets")
	for file_name in files:
		var path = "user://Presets/" + file_name
		var file = FileAccess.open(path, FileAccess.READ)
		if not file: continue
		var content = file.get_as_text()
		file.close()
		
		var data = JSON.parse_string(content)
		if typeof(data) != TYPE_DICTIONARY:
			presetDropdown.add_item(file_name.get_basename())
			continue
			
		var icon_tex: Texture2D = null
		var last_source = data.get("lastSource", "local")
		
		if last_source == "collab":
			var dex_id = data.get("collabDexId", "")
			var form = data.get("collabForm", "Normal")
			var emotion = data.get("collabEmotion", "Normal")
			
			if dex_id != "" and collabPortraitMenu.pokedex.has(dex_id):
				var pkmn = collabPortraitMenu.pokedex[dex_id]
				var relative_path = ""
				if pkmn.forms.has(form):
					relative_path = pkmn.forms[form].relative_path
				
				var img_path = "user://PMDCollab/portrait/" + dex_id + "/"
				if relative_path != "":
					img_path = img_path.path_join(relative_path) + "/"
				img_path += emotion + ".png"
				
				if FileAccess.file_exists(img_path):
					var img = Image.new()
					if img.load(img_path) == OK:
						img.resize(20, 20, Image.INTERPOLATE_NEAREST)
						icon_tex = ImageTexture.create_from_image(img)
		else:
			var custom_name = data.get("customPortraitName", "")
			var custom_emotion = data.get("customPortraitEmotion", "")
			if custom_name != "" and custom_emotion != "":
				var img_path = "user://Portraits/" + custom_name + "/" + custom_emotion
				if FileAccess.file_exists(img_path):
					var img = Image.new()
					if img.load(img_path) == OK:
						img.resize(20, 20, Image.INTERPOLATE_NEAREST)
						icon_tex = ImageTexture.create_from_image(img)
		
		var idx = presetDropdown.item_count
		if icon_tex:
			presetDropdown.add_icon_item(icon_tex, file_name.get_basename())
		else:
			presetDropdown.add_item(file_name.get_basename())
	
	if presetDropdown.item_count > 0:
		set_dropdown_icon_resized(presetDropdown, presetDropdown.selected)
		
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
	SoundEffectManager.PlaySavePreset()
	SaveCurrentStateAsPreset()


func OnDeletePresetPressed():
	SoundEffectManager.PlayDelete()
	DirAccess.remove_absolute("user://Presets/" + presetDropdown.text + ".json");
	RefreshDropdown()

func set_dropdown_icon_resized(dropdown: OptionButton, index: int):
	if index < 0: return
	var full_icon = dropdown.get_item_icon(index)
	if full_icon:
		var img = full_icon.get_image()
		img.resize(16, 16, Image.INTERPOLATE_NEAREST)
		dropdown.icon = ImageTexture.create_from_image(img)
	else:
		dropdown.icon = null
