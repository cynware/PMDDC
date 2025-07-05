extends Control

@export var icon:Sprite2D;
@export var presetImages:Array[Texture2D];

@export var localFolderDropdownLocal:OptionButton;
@export var localEmotionDropdownLocal:OptionButton;


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
			if(icon.texture == null):
				img.resize(40, 40, Image.INTERPOLATE_NEAREST);
				icon.texture = ImageTexture.create_from_image(img);
				icon_texture_changed()
				
			img.resize(20, 20, Image.INTERPOLATE_NEAREST);
			var portraitTexture := ImageTexture.create_from_image(img);
			localEmotionDropdownLocal.add_icon_item(portraitTexture, portraits[i], i);
		
func loadIconLocal():
	var imagepath = "user://Portraits/" + localFolderDropdownLocal.text + "/"+localEmotionDropdownLocal.text;
	
	if(!FileAccess.file_exists(imagepath)):
		return;
		
	var image = Image.load_from_file(imagepath)
	
	if image.load(imagepath) == OK:
		if image.get_width() > 40 or image.get_height() > 40:
			image.resize(40, 40, Image.INTERPOLATE_NEAREST)
	
		var texture = ImageTexture.create_from_image(image)
		icon.texture = texture
		icon_texture_changed()
		

func loadIconCollab():
	# Create an HTTP request node and connect its completion signal.
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(self._http_request_completed)

	# Shiny Check
	var IfShiny = ""
	if $ShinyCheck.button_pressed == true:
		IfShiny = "0000/0001/"
	else:
		IfShiny = ""

	# Perform the HTTP request. The URL below returns a PNG image as of writing.
	var formattedPokemonNumber = "%04d" % int($DexNum.text)
	var error = http_request.request("https://raw.githubusercontent.com/PMDCollab/SpriteCollab/master/portrait/"+ formattedPokemonNumber + "/" + IfShiny + $Emotion_Collab.text + ".png")
	if error != OK:
		push_error("An error occurred in the HTTP request.")
# Called when the HTTP request is completed.

func _http_request_completed(result, response_code, headers, body):
	if result != HTTPRequest.RESULT_SUCCESS:
		push_error("Image couldn't be downloaded. Try a different image.")

	var image = Image.new()
	var error = image.load_png_from_buffer(body)
	if error != OK:
		push_error("Couldn't load the image.")

	var texture = ImageTexture.create_from_image(image)
	icon.texture = texture
	icon_texture_changed()


func icon_texture_changed():
	var tempimg = icon.texture.get_image()
	tempimg.resize(15, 15, Image.INTERPOLATE_NEAREST)
	var resized_img = ImageTexture.create_from_image(tempimg)
	$"../PortraitLeft/PortraitLeftTEXTURE".texture = resized_img
	$"../PortraitRight/PortraitRightTEXTURE".texture = resized_img

func openCustomIconFolder():
	OS.shell_open(ProjectSettings.globalize_path("user://Portraits"))

func OnFolderSelectedChanged(index):
	RetrievePortraitsInDirectory(false)

func OnRefresh():
	RetrievePortraitsInDirectory()

func OnEmotionSelected(index):
	loadIconLocal()
	
