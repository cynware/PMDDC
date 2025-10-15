extends Control

@export var icon:Sprite2D;
@export var presetImages:Array[Texture2D];

@export var localFolderDropdownLocal:OptionButton;
@export var localEmotionDropdownLocal:OptionButton;
@export var errorIcon:Sprite2D;

var curPmdCollabURL = "";

func _ready():
	CheckAndCreatePortraitFolder()
	RetrievePortraitsInDirectory()
	
	# get_window().connect("focus_entered", self, "RetrievePortraitsInDirectory");
	#get_window().connect("focus_entered",  RetrievePortraitsInDirectory)
	

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

	localEmotionDropdownLocal.clear()
	localEmotionDropdownLocal.icon = null;
	icon.texture = null;
	
	if(refreshFolderDropdown):
		localFolderDropdownLocal.clear()
		for dir in DirAccess.get_directories_at("user://Portraits/"):
			localFolderDropdownLocal.add_item(dir);
		
	if(!DirAccess.dir_exists_absolute("user://Portraits/" + localFolderDropdownLocal.text)):
		return;
		
	var portraits = DirAccess.get_files_at("user://Portraits/" + localFolderDropdownLocal.text + "/");
	print(portraits);
		
	for i in portraits.size():
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
			localEmotionDropdownLocal.add_icon_item(portraitTexture, portraits[i], i);
		else:
			errorIcon.visible = true;
			
		
func loadIconLocal():
	curPmdCollabURL = "";
	var imagepath = "user://Portraits/" + localFolderDropdownLocal.text + "/"+localEmotionDropdownLocal.text;
	
	if(!FileAccess.file_exists(imagepath)):
		return;
		
	var image = Image.load_from_file(imagepath)
	
	if image.load(imagepath) == OK:
		errorIcon.visible = false;
		
		if image.get_width() > 40 or image.get_height() > 40:
			image.resize(40, 40, Image.INTERPOLATE_NEAREST)

		var texture = ImageTexture.create_from_image(image)
		icon.texture = texture
		icon_texture_changed()
	else:
		errorIcon.visible = true;
		
func loadIconCollab():
	# Shiny Check
	SoundEffectManager.PlaySavePreset()
		
	# Perform the HTTP request. The URL below returns a PNG image as of writing.
	var formattedPokemonNumber = "%04d" % int($DexNum.text)
	var formattedURL = "https://raw.githubusercontent.com/PMDCollab/SpriteCollab/master/portrait/"+ formattedPokemonNumber + "/" + $Emotion_Collab.text + ".png"
	loadIconCollabFromURL(formattedURL)
# Called when the HTTP request is completed.

func loadIconCollabFromURL(URL:String):
	# Create an HTTP request node and connect its completion signal.
	errorIcon.visible = false;
	
	curPmdCollabURL = URL;
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(self._http_request_completed)

	# Perform the HTTP request. The URL below returns a PNG image as of writing.
	var error = http_request.request(URL)
	if error != OK:
		errorIcon.visible = true;
		push_error("An error occurred in the HTTP request.")
	
func _http_request_completed(result, response_code, headers, body):
	if result != HTTPRequest.RESULT_SUCCESS:
		push_error("Image couldn't be downloaded. Try a different image.")

	var image = Image.new()
	var error = image.load_png_from_buffer(body)
	if error != OK:
		errorIcon.visible = true;
		
		push_error("Couldn't load the image.")

	var texture = ImageTexture.create_from_image(image)
	icon.texture = texture
	icon_texture_changed()

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

var allowedDexNumCharacters = "0123456789";

func OnDexNumChanged(new_text):
	var caret_pos = $DexNum.caret_column 
	var filtered_text = ""
	for char in new_text:
		if char in allowedDexNumCharacters:
			filtered_text += char
	$DexNum.text = filtered_text;
	$DexNum.caret_column = caret_pos;

func _on_shiny_check_toggled(toggled_on):
	if(toggled_on):
		SoundEffectManager.PlayCheckboxOn()
	else:
		SoundEffectManager.PlayCheckboxOff()
		
func _on_emotion_collab_item_selected(index):
	SoundEffectManager.PlayChooseDropdown()
	
func _input(event):
	if(Input.is_action_just_pressed("BACK") and visible):
		visible = false;
		SoundEffectManager.PlayCancel()

func _on_collab_btn_pressed():
	OS.shell_open("https://sprites.pmdcollab.org/")
	var sound_player = SoundEffectManager.get_child(7)
	sound_player.pitch_scale = randf_range(0.95, 1.05)
	sound_player.play()
