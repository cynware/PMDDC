extends Control

@export var icon:Sprite2D;

@export var presetImages:Array[Texture2D];

func _ready():
	if (!DirAccess.dir_exists_absolute("user://Portraits")):
		DirAccess.make_dir_absolute("user://Portraits")
		DirAccess.make_dir_absolute("user://Portraits/Template")
		
		for img in presetImages:
			img.get_image().save_png(ProjectSettings.globalize_path("user://Portraits/Template/" + img.resource_path.get_file()));
		print("MADE PORTRAITS FOLDER + TEMPLATES")
	else:
		print("PORTRAITS FOLDER ALREADY EXISTS")
		
func loadIconCollab():
	# Create an HTTP request node and connect its completion signal.
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(self._http_request_completed)

	# Perform the HTTP request. The URL below returns a PNG image as of writing.
	var error = http_request.request("https://raw.githubusercontent.com/PMDCollab/SpriteCollab/master/portrait/"+ $DexNum.text + "/" + $Emotion_Collab.text + ".png")
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

func loadIconLocal():
	var imagepath = "user://Portraits/"+$LocalName.text+"/"+$Emotion_Local.text+".png"
	var image = Image.load_from_file(imagepath)
	
	if image.load(imagepath) == OK:
		if image.get_width() > 40 or image.get_height() > 40:
			image.resize(40, 40, Image.INTERPOLATE_NEAREST)
	
		var texture = ImageTexture.create_from_image(image)
		icon.texture = texture

func openCustomIconFolder():
	OS.shell_open(ProjectSettings.globalize_path("user://Portraits"))
