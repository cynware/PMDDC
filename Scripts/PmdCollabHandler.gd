extends Control

@onready var dex_num_input = $DexNum
@onready var emotion_dropdown = $Emotion_Collab
@onready var form_dropdown = $Form_Collab
@onready var error_icon = $"../../../../../PMD_Main/Portrait/ERRORICON"
@onready var portrait_icon = $"../../../../../PMD_Main/Portrait/Icon"
@onready var alignment_preview = $"../PORTRAITALIGNMENT/Alignment_Preview"
@onready var open_folder_btn = $OpenCurrentFolder

@export var notice_screen: Control

var pokedex: Dictionary = {}
var allowedDexNumCharacters = "0123456789"
var downloader: PmdCollabDownloader
var current_resolved_id: String = ""
var portrait_credits: Dictionary = {}
var artist_urls: Dictionary = {}

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
	
	var credits_label = get_node_or_null("SpriteCredits")
	if credits_label:
		credits_label.meta_clicked.connect(func(meta): OS.shell_open(str(meta)))
		credits_label.focus_mode = Control.FOCUS_NONE
	
	var bar = get_node_or_null("../LoadCollabPortraitBTN/Download_Bar")
	if bar: bar.visible = false
	
	if PmdCollabDownloader.is_installed():
		load_tracker_data()
		load_credits_data()
	
	if dex_num_input:
		pass
	if emotion_dropdown:
		emotion_dropdown.add_theme_constant_override("icon_max_width", 16)
	if form_dropdown:
		form_dropdown.add_theme_constant_override("icon_max_width", 16)
		form_dropdown.item_selected.connect(_on_form_collab_item_selected)
	
	if open_folder_btn:
		open_folder_btn.pressed.connect(_on_open_current_folder_pressed)
		
	if pokedex.size() > 0 and dex_num_input and dex_num_input.text != "":
		populate_collab_options()
	
	update_open_folder_button()

func load_credits_data():
	var path = "user://PMDCollab/spritebot_credits.txt"
	if not FileAccess.file_exists(path):
		return
		
	var file = FileAccess.open(path, FileAccess.READ)
	if not file:
		return
		
	portrait_credits.clear()
	artist_urls.clear()
	var current_artist = ""
	var in_portrait_section = false
	
	while not file.eof_reached():
		var line = file.get_line()
		var trimmed = line.strip_edges()
		
		if trimmed == "": continue
		
		if not line.begins_with("\t") and not line.begins_with(" "):
			var contact_split = line.split("Contact:", false)
			var name_part = contact_split[0]
			if name_part.contains("Discord:"):
				name_part = name_part.split("Discord:")[0]
			current_artist = name_part.strip_edges()
			
			if contact_split.size() > 1:
				artist_urls[current_artist] = contact_split[1].strip_edges()
			
			in_portrait_section = false
			continue
			
		if trimmed == "Portrait:":
			in_portrait_section = true
			continue
		elif trimmed == "Sprite:":
			in_portrait_section = false
			continue
			
		if in_portrait_section and line.begins_with("\t\t"):
			var portrait_name = trimmed.split(":")[0].strip_edges()
			_add_portrait_credit(portrait_name, current_artist)
			var alt_name = portrait_name.replace(" ", "_")
			if alt_name != portrait_name:
				_add_portrait_credit(alt_name, current_artist)
			
			var parts = portrait_name.split(" ")
			if parts.size() > 1:
				var underscored = parts[0] + "_" + parts[1]
				_add_portrait_credit(underscored, current_artist)

func _add_portrait_credit(p_name: String, artist: String):
	if not portrait_credits.has(p_name):
		portrait_credits[p_name] = []
	if not artist in portrait_credits[p_name]:
		portrait_credits[p_name].append(artist)

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
	
	# Verify directory exists locally
	var check_path = "user://PMDCollab/portrait/" + current_resolved_id + "/"
	if !DirAccess.dir_exists_absolute(check_path):
		if notice_screen:
			var errorText = "Whoo-hoops! You have to put your CD back in your computer!\n\nCould not find the portrait directory for " + pkmn.name + " (" + current_resolved_id + ").\n\nIt seems some files are missing from your PMDCollab folder. Please try refreshing or re-downloading."
			notice_screen.ShowNoticeScreen(errorText);
		return

	var forms = pkmn.forms.keys()
	forms.sort()
	if forms.has("Normal"):
		forms.erase("Normal")
		forms.push_front("Normal")

	for form_key in forms:
		var form_data: FormData = pkmn.forms[form_key]
		var relative_path = form_data.relative_path
		var form_base_path = "user://PMDCollab/portrait/" + current_resolved_id + "/"
		if relative_path != "":
			form_base_path = form_base_path.path_join(relative_path) + "/"
		
		var icon_tex: Texture2D = null
		var normal_path = form_base_path + "Normal.png"
		
		if FileAccess.file_exists(normal_path):
			var img = Image.new()
			if img.load(normal_path) == OK:
				img.resize(20, 20, Image.INTERPOLATE_NEAREST)
				icon_tex = ImageTexture.create_from_image(img)
		
		if icon_tex == null:
			if DirAccess.dir_exists_absolute(form_base_path):
				var files = DirAccess.get_files_at(form_base_path)
				for file in files:
					if file.ends_with(".png") and not file.get_basename().ends_with("^"):
						var img = Image.new()
						if img.load(form_base_path + file) == OK:
							img.resize(20, 20, Image.INTERPOLATE_NEAREST)
							icon_tex = ImageTexture.create_from_image(img)
							break
		
		if icon_tex:
			form_dropdown.add_icon_item(icon_tex, str(form_key))
		else:
			form_dropdown.add_item(str(form_key))
	
	if form_dropdown.item_count > 0:
		form_dropdown.selected = 0
		set_dropdown_icon_resized(form_dropdown, 0)
	
	update_emotion_options(play_sound)

func update_emotion_options(play_sound: bool = true, preserve_selection: bool = false):
	update_open_folder_button()
	if current_resolved_id == "" or !pokedex.has(current_resolved_id): return
	
	var pkmn = pokedex[current_resolved_id]
	var current_form = "Normal"
	if form_dropdown.item_count > 0:
		current_form = form_dropdown.text
	
	var flip_toggle = get_node_or_null("../PortraitFlip")
	var is_flipped = flip_toggle.button_pressed if flip_toggle else false
	
	var old_text = emotion_dropdown.get_item_text(emotion_dropdown.selected) if emotion_dropdown.selected >= 0 else ""
	emotion_dropdown.clear()
	
	if pkmn.forms.has(current_form):
		var form_data: FormData = pkmn.forms[current_form]
		var relative_path = form_data.relative_path
		var base_path = "user://PMDCollab/portrait/" + current_resolved_id + "/"
		if relative_path != "":
			base_path = base_path.path_join(relative_path) + "/"
			
		var emotions_to_show = []
		for emotion in form_data.emotions:
			if not emotion.ends_with("^"):
				emotions_to_show.append(emotion)
		
		emotions_to_show.sort()
		if emotions_to_show.has("Normal"):
			emotions_to_show.erase("Normal")
			emotions_to_show.push_front("Normal")
			
		var item_idx = 0
		for emotion in emotions_to_show:
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
		if preserve_selection:
			for i in range(emotion_dropdown.item_count):
				if emotion_dropdown.get_item_text(i) == old_text:
					emotion_dropdown.selected = i
					break
		else:
			emotion_dropdown.selected = 0
		loadIconCollab(play_sound)
	
	if emotion_dropdown.selected >= 0:
		set_dropdown_icon_resized(emotion_dropdown, emotion_dropdown.selected)

func loadIconCollab(play_sound: bool = true):
	if play_sound:
		SoundEffectManager.PlaySavePreset()
	
	var credits_label = get_node_or_null("SpriteCredits")
	if credits_label:
		credits_label.text = ""
	
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
			
			if credits_label:
				var pkmn_name = pokedex[id].name
				var lookup_name = pkmn_name
				if current_form != "Normal":
					lookup_name = pkmn_name + " " + current_form
				
				var artists = portrait_credits.get(lookup_name, [])
				if artists.is_empty():
					artists = portrait_credits.get(lookup_name.replace(" ", "_"), [])
				
				if artists.is_empty():
					credits_label.text = "[center]SPRITE SET CREDIT:[color=f8f800]\nUnknown"
				else:
					var display_text = "[center]SPRITE SET CREDIT:[color=f8f800]\n"
					for i in range(artists.size()):
						var artist_name = artists[i]
						var url = artist_urls.get(artist_name, "")
						if url != "":
							display_text += "[url=" + url + "]" + artist_name + "[/url]"
						else:
							display_text += artist_name
						
						if i < artists.size() - 1:
							display_text += ", "
					credits_label.text = display_text
		else:
			if error_icon: error_icon.visible = true
			if notice_screen:
				var errorText = "Whoo-hoops! You have to put your CD back in your computer!\n\nFailed to load the portrait image: " + file_path.get_file() + "\n\nThe file might be corrupted."
				notice_screen.ShowNoticeScreen(errorText);
			push_error("Failed to load image: " + file_path)
	else:
		if error_icon: error_icon.visible = true
		if notice_screen:
			var pkmn_name = pokedex[id].name
			var errorText = "Whoo-hoops! You have to put your CD back in your computer!\n\nCould not find the portrait file for " + pkmn_name + " (" + emotion + ").\n\nMake sure the portrait database is fully downloaded."
			notice_screen.ShowNoticeScreen(errorText);
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
	set_dropdown_icon_resized(emotion_dropdown, index)

func _on_form_collab_item_selected(index):
	SoundEffectManager.PlayChooseDropdown()
	set_dropdown_icon_resized(form_dropdown, index)
	update_emotion_options()

func set_dropdown_icon_resized(dropdown: OptionButton, index: int):
	if index < 0: return
	var full_icon = dropdown.get_item_icon(index)
	if full_icon:
		var img = full_icon.get_image()
		img.resize(16, 16, Image.INTERPOLATE_NEAREST)
		dropdown.icon = ImageTexture.create_from_image(img)
	else:
		dropdown.icon = null

func _on_collab_btn_pressed():
	OS.shell_open("https://sprites.pmdcollab.org/")

func _on_refresh_btn_pressed():
	if PmdCollabDownloader.is_installed():
		load_tracker_data()
		load_credits_data()
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
		load_credits_data()
		populate_collab_options()
	else:
		print("PMDCollab Download Failed.")
		var bar = get_node_or_null("../LoadCollabPortraitBTN/Download_Bar")
		if bar: bar.visible = false
		
		if notice_screen:
			var errorText = "Whoo-hoops! You have to put your CD back in your computer!\n\nFailed to download or extract the PMDCollab portrait database. :(\n\nPlease check your internet connection and storage space, then try again."
			notice_screen.ShowNoticeScreen(errorText);
