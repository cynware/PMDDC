extends Control

@onready var dex_num_input = $DexNum
@onready var emotion_dropdown = $Emotion_Collab
@onready var form_dropdown = $Form_Collab
@onready var error_icon = $"../../../../../PMD_Main/Portrait/ERRORICON"
@onready var portrait_icon = $"../../../../../PMD_Main/Portrait/Icon"
@onready var alignment_preview = $"../PORTRAITALIGNMENT/Alignment_Preview"

var pokedex: Dictionary = {}
var allowedDexNumCharacters = "0123456789"

func _ready():
	var downloader = PmdCollabDownloader.new()
	add_child(downloader)
	if PmdCollabDownloader.is_installed():
		load_tracker_data()
	else:
		downloader.start_download()
	
	if dex_num_input:
		pass
		#dex_num_input.text_changed.connect(OnDexNumChanged)
	if emotion_dropdown:
		pass
		#emotion_dropdown.item_selected.connect(_on_emotion_collab_item_selected)
	if form_dropdown:
		pass
		#form_dropdown.item_selected.connect(_on_form_collab_item_selected)
		
	if pokedex.size() > 0 and dex_num_input and dex_num_input.text != "":
		populate_collab_options()

func load_tracker_data():
	var path = "user://PMDCollab/tracker.json"
	if FileAccess.file_exists(path):
		var file = FileAccess.open(path, FileAccess.READ)
		if file:
			var content = file.get_as_text()
			file.close()
			var json = JSON.parse_string(content)
			if typeof(json) == TYPE_DICTIONARY:
				pokedex = PokemonData.from_json_root(json)
				print("PmdCollabHandler: Loaded " + str(pokedex.size()) + " entries.")

func OnDexNumChanged(new_text):
	var caret_pos = dex_num_input.caret_column 
	var filtered_text = ""
	for char in new_text:
		if char in allowedDexNumCharacters:
			filtered_text += char
	dex_num_input.text = filtered_text;
	dex_num_input.caret_column = caret_pos;
	
	populate_collab_options()

func populate_collab_options():
	var id = "%04d" % int(dex_num_input.text)
	
	emotion_dropdown.clear()
	form_dropdown.clear()
	
	if !pokedex.has(id): return

	var pkmn = pokedex[id]
	
	for form_key in pkmn.forms.keys():
		form_dropdown.add_item(str(form_key))
	
	update_emotion_options()

func update_emotion_options():
	var id = "%04d" % int(dex_num_input.text)
	if !pokedex.has(id): return
	
	var pkmn = pokedex[id]
	var current_form = "Normal"
	if form_dropdown.item_count > 0:
		current_form = form_dropdown.text
	
	emotion_dropdown.clear()
	
	if pkmn.forms.has(current_form):
		var form_data: FormData = pkmn.forms[current_form]
		for emotion in form_data.emotions:
			emotion_dropdown.add_item(emotion)
			
	if emotion_dropdown.item_count > 0:
		emotion_dropdown.selected = 0
		loadIconCollab()

func loadIconCollab():
	SoundEffectManager.PlaySavePreset()
	
	var id = "%04d" % int(dex_num_input.text)
	if emotion_dropdown.item_count == 0: return
	var emotion = emotion_dropdown.text
	var current_form = "Normal"
	if form_dropdown.item_count > 0:
		current_form = form_dropdown.text
		
	if !pokedex.has(id): return
	var pkmn = pokedex[id]
	
	var relative_path = ""
	if pkmn.forms.has(current_form):
		relative_path = pkmn.forms[current_form].relative_path
	
	var base_path = "user://PMDCollab/portrait/" + id + "/"
	if relative_path != "":
		base_path = base_path.path_join(relative_path) + "/"
		
	var file_path = base_path + emotion + ".png"
	
	if FileAccess.file_exists(file_path):
		var image = Image.new()
		var error = image.load(file_path)
		if error == OK:
			if error_icon: error_icon.visible = false
			
			if image.get_width() > 40 or image.get_height() > 40:
				image.resize(40, 40, Image.INTERPOLATE_NEAREST)
			
			var texture = ImageTexture.create_from_image(image)
			if portrait_icon: 
				portrait_icon.texture = texture
				update_alignment_preview()
		else:
			if error_icon: error_icon.visible = true
			push_error("Failed to load image: " + file_path)
	else:
		if error_icon: error_icon.visible = true
		print("File not found: " + file_path)

func update_alignment_preview():
	if !portrait_icon or !portrait_icon.texture: return
	if !alignment_preview: return
	
	var tempimg = portrait_icon.texture.get_image()
	tempimg.resize(15, 15, Image.INTERPOLATE_NEAREST)
	var resized_img = ImageTexture.create_from_image(tempimg)
	alignment_preview.texture = resized_img

func _on_emotion_collab_item_selected(index):
	SoundEffectManager.PlayChooseDropdown()
	loadIconCollab()

func _on_form_collab_item_selected(index):
	SoundEffectManager.PlayChooseDropdown()
	update_emotion_options()

func _on_collab_btn_pressed():
	OS.shell_open("https://sprites.pmdcollab.org/")

func _on_refresh_btn_pressed():
	if PmdCollabDownloader.is_installed():
		load_tracker_data()
		populate_collab_options()
		SoundEffectManager.PlayRefresh()
	
func openCustomIconFolder():
	OS.shell_open(ProjectSettings.globalize_path("user://PMDCollab/portrait"))
	SoundEffectManager.PlayFolder()
