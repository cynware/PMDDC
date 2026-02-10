extends Control

@export var icon:Sprite2D;
@export var presetImages:Array[Texture2D];

@export var localFolderDropdownLocal:OptionButton;
@export var localEmotionDropdownLocal:OptionButton;
@export var errorIcon:Sprite2D;

var emotions = []

func _ready():
	CheckAndCreatePortraitFolder()
	RetrievePortraitsInDirectory()
	
func CheckAndCreatePortraitFolder():
	if (!DirAccess.dir_exists_absolute("user://Portraits")):
		DirAccess.make_dir_absolute("user://Portraits")
		DirAccess.make_dir_absolute("user://Portraits/Template")
		
		for img in presetImages:
			img.get_image().save_png(ProjectSettings.globalize_path("user://Portraits/Template/" + img.resource_path.get_file()));
		print("MADE PORTRAITS FOLDER + TEMPLATES")
	else:
		print("PORTRAITS FOLDER ALREADY EXISTS")

func RetrievePortraitsInDirectory(refreshFolderDropdown = true):
	emotions.clear()
	localEmotionDropdownLocal.clear()
	localEmotionDropdownLocal.icon = null;
	icon.texture = null;
	
	if(refreshFolderDropdown):
		localFolderDropdownLocal.clear()
		for dir in DirAccess.get_directories_at("user://Portraits/"):
			var img := Image.new()
			var localportraits = DirAccess.get_files_at("user://Portraits/" + dir + "/")
			
			if localportraits.size() > 0:
				var error = img.load("user://Portraits/" + dir + "/" + localportraits[0])

				if error == OK:
					errorIcon.visible = false;
					
					if(icon.texture == null):
						img.resize(40, 40, Image.INTERPOLATE_NEAREST);
						icon.texture = ImageTexture.create_from_image(img);
						icon_texture_changed()
						
					img.resize(20, 20, Image.INTERPOLATE_NEAREST);
					var portraitTexture := ImageTexture.create_from_image(img);
					localFolderDropdownLocal.add_icon_item(portraitTexture, dir, 0);
				else:
					errorIcon.visible = true;
		
	if localFolderDropdownLocal.item_count == 0: return

	var portraits = DirAccess.get_files_at("user://Portraits/" + localFolderDropdownLocal.text + "/");
	
	if(!DirAccess.dir_exists_absolute("user://Portraits/" + localFolderDropdownLocal.text)):
		return;
		
	for i in portraits.size():
		if portraits[i].get_basename().ends_with("^"):
			continue
			
		var img := Image.new()
		var error = img.load("user://Portraits/" + localFolderDropdownLocal.text + "/" + portraits[i])

		if error == OK:
			errorIcon.visible = false;
			
			if(icon.texture == null):
				img.resize(40, 40, Image.INTERPOLATE_NEAREST);
				icon.texture = ImageTexture.create_from_image(img);
				icon_texture_changed()
				
			img.resize(20, 20, Image.INTERPOLATE_NEAREST);
			var portraitTexture := ImageTexture.create_from_image(img);
			emotions.append(portraits[i])
			localEmotionDropdownLocal.add_icon_item(portraitTexture, portraits[i].get_basename(), emotions.size() - 1);
		else:
			errorIcon.visible = true;
			
	print(emotions)
		
func loadIconLocal():
	var basename = emotions[localEmotionDropdownLocal.get_selected_id()].get_basename()
	var extension = emotions[localEmotionDropdownLocal.get_selected_id()].get_extension()
	var base_path = "user://Portraits/" + localFolderDropdownLocal.text + "/"
	
	var flip_toggle = get_node_or_null("../PortraitFlip")
	var is_flipped = flip_toggle.button_pressed if flip_toggle else false
	
	var file_path = base_path + basename + "." + extension
	var flipped_file_path = base_path + basename + "^." + extension
	var use_flipped_variant = false
	
	if is_flipped and FileAccess.file_exists(flipped_file_path):
		file_path = flipped_file_path
		use_flipped_variant = true
		
	if(!FileAccess.file_exists(file_path)):
		return;
		
	var image = Image.load_from_file(file_path)
	
	if image.load(file_path) == OK:
		errorIcon.visible = false;
		
		if image.get_width() > 40 or image.get_height() > 40:
			image.resize(40, 40, Image.INTERPOLATE_NEAREST)

		var texture = ImageTexture.create_from_image(image)
		icon.texture = texture
		icon.set_meta("last_source", "local")
		
		if is_flipped and not use_flipped_variant:
			icon.scale.x = -1
		else:
			icon.scale.x = 1
			
		icon_texture_changed()
	else:
		errorIcon.visible = true;

func icon_texture_changed():
	if(icon.texture == null):
		return;
		
	var tempimg = icon.texture.get_image()
	tempimg.resize(15, 15, Image.INTERPOLATE_NEAREST)
	var resized_img = ImageTexture.create_from_image(tempimg)
	$"../../PortraitTab/PORTRAITALIGNMENT/Alignment_Preview".texture = resized_img

func openCustomIconFolder():
	OS.shell_open(ProjectSettings.globalize_path("user://Portraits"))
	SoundEffectManager.PlayFolder()

func OnFolderSelectedChanged(index):
	SoundEffectManager.PlayChooseDropdown()
	RetrievePortraitsInDirectory(false)

func OnRefresh():
	RetrievePortraitsInDirectory()
	SoundEffectManager.PlayRefresh()

func OnEmotionSelected(index):
	SoundEffectManager.PlayChooseDropdown()	
	loadIconLocal()

func _input(event):
	if(Input.is_action_just_pressed("BACK") and visible):
		visible = false;
		SoundEffectManager.PlayCancel()
