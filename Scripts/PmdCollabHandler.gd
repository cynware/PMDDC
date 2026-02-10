extends Control

@onready var dex_num_input = $DexNum
@onready var emotion_dropdown = $Emotion_Collab
@onready var form_dropdown = $Form_Collab
@onready var error_icon = $"../../../../../PMD_Main/Portrait/ERRORICON"
@onready var portrait_icon = $"../../../../../PMD_Main/Portrait/Icon"
@onready var alignment_preview = $"../PORTRAITALIGNMENT/Alignment_Preview"
@onready var open_folder_btn = $OpenCurrentFolder

var pokedex: Dictionary = {}
var allowedDexNumCharacters = "0123456789"
var downloader: PmdCollabDownloader
var current_resolved_id: String = ""

const DOWNLOAD_SCREEN_BASE_TEXT = "[center]Oh, Hi! Would you like to download all portraits from [img]res://Assets/Images/PMDCollab.png[/img] [color=f8f800]PMDCollab[/color]?\n[color=9c9c9c](You can still use PMDDC while the download is going, hehe!)[/color]\nThe size of the download is: "

func _ready():
	downloader = PmdCollabDownloader.new()
	add_child(downloader)
	
	downloader.download_percent.connect(_on_download_percent)
	downloader.size_fetched.connect(_on_size_fetched)
	downloader.download_completed.connect(_on_download_completed)
	
	var download_screen = get_node_or_null("../../../../../DownloadScreen")
	if download_screen:
		download_screen.visibility_changed.connect(_on_download_screen_visibility_changed)
		var yes_btn = download_screen.get_node_or_null("InfoBorder/InfoDisplay/YesBTN")
		if yes_btn: yes_btn.pressed.connect(_on_download_yes_pressed)
		var close_btn = download_screen.get_node_or_null("InfoBorder/InfoDisplay/CloseBTN")
		if close_btn: close_btn.pressed.connect(func(): download_screen.visible = false)
	
	var bar = get_node_or_null("../LoadCollabPortraitBTN/Download_Bar")
	if bar: bar.visible = false
	
	if PmdCollabDownloader.is_installed():
		load_tracker_data()
	
	if dex_num_input:
		pass
	if emotion_dropdown:
		pass
	if form_dropdown:
		form_dropdown.item_selected.connect(_on_form_collab_item_selected)
	
	if open_folder_btn:
		open_folder_btn.pressed.connect(_on_open_current_folder_pressed)
		
	if pokedex.size() > 0 and dex_num_input and dex_num_input.text != "":
		populate_collab_options()
	
	update_open_folder_button()

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
	populate_collab_options(false)

func populate_collab_options(play_sound: bool = true):
	var input = dex_num_input.text.strip_edges()
	current_resolved_id = ""
	
	if input.is_valid_int():
		current_resolved_id = "%04d" % input.to_int()
	
	if current_resolved_id == "" or !pokedex.has(current_resolved_id):
		var search_name = input.to_lower()
		for p_id in pokedex:
			if pokedex[p_id].name.to_lower() == search_name:
				current_resolved_id = p_id
				break
	
	emotion_dropdown.clear()
	form_dropdown.clear()
	
	var flip_toggle = get_node_or_null("../PortraitFlip")
	if flip_toggle:
		flip_toggle.button_pressed = false
	if portrait_icon:
		portrait_icon.scale.x = 1
	
	update_open_folder_button()
	
	if current_resolved_id == "" or !pokedex.has(current_resolved_id): return

	var pkmn = pokedex[current_resolved_id]
	
	for form_key in pkmn.forms.keys():
		form_dropdown.add_item(str(form_key))
	
	if form_dropdown.item_count > 0:
		form_dropdown.selected = 0
	
	update_emotion_options(play_sound)

func update_emotion_options(play_sound: bool = true):
	update_open_folder_button()
	if current_resolved_id == "" or !pokedex.has(current_resolved_id): return
	
	var pkmn = pokedex[current_resolved_id]
	var current_form = "Normal"
	if form_dropdown.item_count > 0:
		current_form = form_dropdown.text
	
	emotion_dropdown.clear()
	
	if pkmn.forms.has(current_form):
		var form_data: FormData = pkmn.forms[current_form]
		var relative_path = form_data.relative_path
		var base_path = "user://PMDCollab/portrait/" + current_resolved_id + "/"
		if relative_path != "":
			base_path = base_path.path_join(relative_path) + "/"
			
		var item_idx = 0
		for emotion in form_data.emotions:
			if not emotion.ends_with("^"):
				var file_path = base_path + emotion + ".png"
				if FileAccess.file_exists(file_path):
					var img = Image.new()
					if img.load(file_path) == OK:
						img.resize(20, 20, Image.INTERPOLATE_NEAREST)
						var tex = ImageTexture.create_from_image(img)
						emotion_dropdown.add_icon_item(tex, emotion, item_idx)
						item_idx += 1
						continue
				
				emotion_dropdown.add_item(emotion, item_idx)
				item_idx += 1
			
	if emotion_dropdown.item_count > 0:
		emotion_dropdown.selected = 0
		loadIconCollab(play_sound)

func loadIconCollab(play_sound: bool = true):
	if play_sound:
		SoundEffectManager.PlaySavePreset()
	
	if current_resolved_id == "" or !pokedex.has(current_resolved_id): return
	var id = current_resolved_id
	
	if emotion_dropdown.item_count == 0: return
	var emotion = emotion_dropdown.text
	var current_form = "Normal"
	if form_dropdown.item_count > 0:
		current_form = form_dropdown.text
		
	var pkmn = pokedex[id]
	
	var relative_path = ""
	if pkmn.forms.has(current_form):
		relative_path = pkmn.forms[current_form].relative_path
	
	var base_path = "user://PMDCollab/portrait/" + id + "/"
	if relative_path != "":
		base_path = base_path.path_join(relative_path) + "/"
	
	var flip_toggle = get_node_or_null("../PortraitFlip")
	var is_flipped = flip_toggle.button_pressed if flip_toggle else false
	
	var file_path = base_path + emotion + ".png"
	var flipped_file_path = base_path + emotion + "^.png"
	var use_flipped_variant = false
	
	if is_flipped and FileAccess.file_exists(flipped_file_path):
		file_path = flipped_file_path
		use_flipped_variant = true
	
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
				portrait_icon.set_meta("last_source", "collab")
				
				if is_flipped:
					if use_flipped_variant:
						portrait_icon.scale.x = 1
					else:
						portrait_icon.scale.x = -1
				else:
					portrait_icon.scale.x = 1
					
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

func update_open_folder_button():
	if !open_folder_btn: return
	
	if current_resolved_id == "" or !pokedex.has(current_resolved_id):
		open_folder_btn.disabled = true
		return
		
	var pkmn = pokedex[current_resolved_id]
	var current_form = "Normal"
	if form_dropdown.item_count > 0:
		current_form = form_dropdown.text
	
	var relative_path = ""
	if pkmn.forms.has(current_form):
		relative_path = pkmn.forms[current_form].relative_path
	
	var base_path = "user://PMDCollab/portrait/" + current_resolved_id + "/"
	if relative_path != "":
		base_path = base_path.path_join(relative_path) + "/"
		
	open_folder_btn.disabled = !DirAccess.dir_exists_absolute(base_path)

func _on_open_current_folder_pressed():
	if current_resolved_id == "" or !pokedex.has(current_resolved_id): return
	var pkmn = pokedex[current_resolved_id]
	var current_form = "Normal"
	if form_dropdown.item_count > 0:
		current_form = form_dropdown.text
	
	var relative_path = ""
	if pkmn.forms.has(current_form):
		relative_path = pkmn.forms[current_form].relative_path
	
	var base_path = "user://PMDCollab/portrait/" + current_resolved_id + "/"
	if relative_path != "":
		base_path = base_path.path_join(relative_path) + "/"
	
	if DirAccess.dir_exists_absolute(base_path):
		OS.shell_open(ProjectSettings.globalize_path(base_path))
		SoundEffectManager.PlayFolder()

func _on_download_screen_visibility_changed():
	var download_screen = get_node("../../../../../DownloadScreen")
	if download_screen.visible:
		var info_text = get_node_or_null("../../../../../DownloadScreen/InfoBorder/InfoDisplay/InfoText")
		if info_text:
			info_text.text = DOWNLOAD_SCREEN_BASE_TEXT + "..."
		downloader.fetch_size()

func _on_size_fetched(size_text):
	var info_text = get_node_or_null("../../../../../DownloadScreen/InfoBorder/InfoDisplay/InfoText")
	if info_text:
		info_text.text = DOWNLOAD_SCREEN_BASE_TEXT + "[color=f8f800]" + size_text + "[/color]"

func _on_download_yes_pressed():
	var download_screen = get_node("../../../../../DownloadScreen")
	if download_screen.visible:
		download_screen.visible = false
		var bar = get_node_or_null("../LoadCollabPortraitBTN/Download_Bar")
		if bar:
			bar.visible = true
			bar.value = 0
		downloader.start_download()

func _on_download_percent(value):
	var bar = get_node_or_null("../LoadCollabPortraitBTN/Download_Bar")
	if bar:
		bar.visible = true
		bar.value = value

func _on_download_completed(success):
	if success:
		print("PMDCollab Download Completed Successfully!")
		var bar = get_node_or_null("../LoadCollabPortraitBTN/Download_Bar")
		if bar: bar.visible = false
		load_tracker_data()
		populate_collab_options()
	else:
		print("PMDCollab Download Failed.")
