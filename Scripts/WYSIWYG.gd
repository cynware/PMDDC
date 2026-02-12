extends Control

@onready var frontend: RichTextLabel = $Frontend_Editor
@onready var boxstorage: RichTextLabel = $Textbox_Storage
@onready var backend: TextEdit = $Backend_Editor
@export var Picker: ColorPickerButton

@onready var text_edit = $Backend_Editor
@onready var toggle_button = $UnownModeToggleBTN

var unown_mode := false

var map = {
	"A": "Ⓐ", "B": "Ⓑ", "C": "Ⓒ", "D": "Ⓓ", "E": "Ⓔ",
	"F": "Ⓕ", "G": "Ⓖ", "H": "Ⓗ", "I": "Ⓘ", "J": "Ⓙ",
	"K": "Ⓚ", "L": "Ⓛ", "M": "Ⓜ", "N": "Ⓝ", "O": "Ⓞ",
	"P": "Ⓟ", "Q": "Ⓠ", "R": "Ⓡ", "S": "Ⓢ", "T": "Ⓣ",
	"U": "Ⓤ", "V": "Ⓥ", "W": "Ⓦ", "X": "Ⓧ", "Y": "Ⓨ", "Z": "Ⓩ",
	"!": "ⓐ", "?": "ⓑ"
}


var edit_mode = true

var text_data = []
var last_text = ""

var internal_clipboard = []

var syncing_backend = false
var syncing_frontend = false

var pending_text_change = false
var text_change_timer = 0.0

var rng = RandomNumberGenerator.new()
var natures = [
	"bold",
	"brave",
	"calm",
	"docile",
	"hardy",
	"hasty",
	"impish",
	"jolly",
	"lonely",
	"naïve",
	"quiet",
	"quirky",
	"rash",
	"relaxed",
	"sassy",
	"timid"
]
var placeholdersplashes = [
	"Welcome to the world of Pokémon!",
	"Try out Skytemple, too!",
	"Blah blah blah...",
	"Put your dialogue here!",
	"Everyone at PMDCollab is amazing, yup yup!",
	"You seem to be...the " + natures[0] + " type!",
	"Honoring the legacy of Pokémon Mystery\nDungeon: Comic Maker!",
	"Make us right!",
	"(HE HAS THEM? FEET?)",
	"YOOM...TAH!",
	"SMILES GO FOR MILES!",
	"By golly!",
	"Rem burst into spontaneous\nlaughter and fainted!",
	"Got 1% more accurate since last update!",
	"No secrets here, you know...",
	"- Removed Missingno.",
	"Originally made for Rats N' Ribbons!",
	"Partially powered by a beaver and a dream!",
	"The sky had a Pokémon!",
	"Check out Perish Song, too!"
]

func _ready():
	last_text = backend.text
	natures.shuffle()
	placeholdersplashes[6] = "You seem to be...the " + natures[0] + " type!"
	placeholdersplashes.shuffle()
	backend.placeholder_text = placeholdersplashes[0]
	#backend.placeholder_text = "Partially powered by a beaver and a dream!"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if syncing_frontend :
		backend.editable = false
	else:
		backend.editable = true
		
	if pending_text_change:
		text_change_timer -= delta
		if text_change_timer <= 0.0:
			pending_text_change = false
			apply_text_change()
			
	
func _on_unown_mode_toggle_pressed():
	unown_mode = !unown_mode
	
func _on_textbox_edit_gui_input(event):
	if unown_mode:
		if event is InputEventKey and event.pressed and not event.echo:
			var char = char(event.unicode)
			var upper_char = char.to_upper()

			if upper_char in map.keys():
				text_edit.insert_text_at_caret(map[upper_char])
				$"../TextboxEdit".accept_event()
			_on_text_changed()
			

func _input(event):
	if $Backend_Editor.has_focus():
		if event is InputEventKey and event.pressed and not event.echo:
			if event.ctrl_pressed:
				match event.keycode:
					KEY_C:
						#print("copied!")
						copy_selection_to_clipboard()
						get_viewport().set_input_as_handled()
						return
					KEY_X:
						#print("cut!")
						copy_selection_to_clipboard(true)
						get_viewport().set_input_as_handled()
						return
					KEY_V:
						#print("pasted!")
						paste_from_clipboard()
						get_viewport().set_input_as_handled()
						return
					KEY_A:
						backend.select_all()
	else:
		pass
	
	

func _on_text_changed():
	if syncing_backend or syncing_frontend:
		return
	apply_text_change()
	
func apply_text_change():
	var new_text = backend.text
	var caret_index = backend.get_caret_column() + get_chars_before_line(backend.get_caret_line())

	var old_text = last_text
	var old_len = old_text.length()
	var new_len = new_text.length()
	var min_len = min(old_len, new_len)

	var prefix = 0
	while prefix < min_len and old_text[prefix] == new_text[prefix]:
		prefix += 1

	var suffix = 0
	while suffix < (min_len - prefix) and old_text[old_len - 1 - suffix] == new_text[new_len - 1 - suffix]:
		suffix += 1
		
	var removed_length = old_len - prefix - suffix
	var added_length = new_len - prefix - suffix
	var added_text = ""
	if added_length > 0:
		added_text = new_text.substr(prefix, added_length)

	if removed_length > 0:
		handle_backspace(prefix, removed_length)

	if added_length > 0:
		add_text_data(added_text, prefix)
		SoundEffectManager.PlayType()
	elif removed_length > 0 and added_length == 0:
		SoundEffectManager.PlayTypeback()

	last_text = new_text
	update_display()
	
	# DEBUGGER! Watches out for mismatch between frontend and backend :) you can thank me later, future me
	
	var Watchog = ""
	for r in text_data:
		if r.type == "text":
			Watchog += r.text
		elif r.type == "img":
			var rsize = r.get("size", 0)
			if rsize == 12:
				Watchog += ""
			elif rsize == 11:
				Watchog += ""
			elif rsize == 10:
				Watchog += ""
			elif rsize == 8:
				Watchog += ""
			elif rsize == 7:
				Watchog += "❝"
			elif rsize == 6:
				Watchog += ""
			elif rsize == 5:
				Watchog += ""
			elif rsize == 22:
				Watchog += ""
			else:
				Watchog += ""

	if Watchog != backend.text:
		print("SYNC MISMATCH: [", Watchog, "] |  vs | [", backend.text, "]")

func get_chars_before_line(line_index: int):
	var count = 0
	for i in range(line_index):
		count += backend.get_line(i).length() + 1
	return count

func add_text_data(txt2add: String, caret_index: int):
	var result = find_row_by_caret(caret_index)
	var row_index = result[0]
	var local_index = result[1]
	
	if row_index == -1:
		for ch in txt2add:
			text_data.append({ "type": "text", "text": ch, "color": Picker.get_pick_color()})
		return
	
	var row = text_data[row_index]
	var t = row.get("type", "text")

	var insert_index = row_index
	if t == "text" or t == "img":
		if local_index > 0:
			insert_index = row_index + 1
		else:
			insert_index = row_index
			
	for ch in txt2add:
		text_data.insert(insert_index, { "type": "text", "text": ch, "color": Picker.get_pick_color()})
		insert_index += 1
	

func handle_backspace(caret_index: int, count: int):
	var start_index = caret_index
	
	count = min(count, text_data.size() - start_index)
	
	if start_index < 0:
		start_index = 0
	for i in range(count):
		if start_index < text_data.size():
			text_data.remove_at(start_index)
		else:
			break
		
func get_absolute_index(line: int, column: int):
	var count = 0
	for i in range(line):
		count += backend.get_line(i).length() + 1
	return count + column
	
	
func find_row_by_caret(caret_index: int):
	var total = 0
		
	for i in range(text_data.size()):
		var row = text_data[i]
		var t = row.get("type", "text")
		var length = 0
		
		if t == "text" or t == "img":
			length = 1
		else:
			length = 0
		
		if caret_index < total + length:
			return [i, caret_index - total]
		total += length
		
	return [-1, 0]



func update_display():
	var font := frontend.get_theme_font("normal_font")
	var font_size := frontend.get_theme_font_size("normal_font_size")
	var max_width = frontend.size.x

	#actually make the output look the way it should
	var WYS_output = ""
	var Box_output = ""
	var line_width = 0.0
	
	for row in text_data:
		var t = row.get("type", "text")
		if t == "text":
			var ch = row.text
			var ch_width = font.get_string_size(ch, font_size).x
			if ch == "\n":
				line_width = 0.0
			if line_width + ch_width > max_width and ch != "\n":
				WYS_output += "\n"
				line_width = 0.0
			var color_hex = row.color.to_html(false)
			WYS_output += "[color=%s]%s[/color]" % [color_hex, row.text]
			Box_output += "[color=%s]%s[/color]" % [color_hex, row.text]
			line_width += ch_width
		elif t == "img":
			var src = row.get("src", "")
			var img_width = row.get("size", "")
			if line_width + img_width > max_width:
				WYS_output += "\n"
				line_width = 0.0
			WYS_output += "[img]%s[/img]" % src
			Box_output += "[img]%s[/img]" % src
			line_width += img_width
	frontend.text = WYS_output
	boxstorage.text = Box_output
	
	$"..".updateHUD()
	
	#print(text_data)

func update_backend(caret_wrap: bool = false):
	syncing_frontend = true
	syncing_backend = true
	
	
	var old_line = backend.get_caret_line()
	var old_col = backend.get_caret_column()

	
	var new_text = ""
	for row in text_data:
		if row.type == "text":
			new_text += row.text
		elif row.type == "img":
			var rsize = row.get("size", "")
			if rsize == 12:
				new_text += "" #downarrowicon
			elif rsize == 11:
				new_text += "" #acontrollericon
			elif rsize == 10:
				new_text += "" #backpackicon
			elif rsize == 8:
				new_text += "" #eggicon
			elif rsize == 7:
				new_text += "❝" #uni275D
			elif rsize == 6:
				new_text += "" # halfwidthzero
			elif rsize == 5:
				new_text += "" # halfstaricon
			elif rsize == 22:
				new_text += "" # controllerselecticon
			else:
				new_text += ""
				
	backend.text = new_text
	last_text = new_text
	
	if caret_wrap == true:
		call_deferred("_restore_caret", old_line, old_col, true)
	else:
		call_deferred("_restore_caret", old_line, old_col, false)
	

func _restore_caret(line: int, col: int, caret_wrap: bool = false):
	var wrap_amount = internal_clipboard.size()
	# Clamp values so they stay valid after update
	line = clamp(line, 0, backend.get_line_count() - 1)
	col = clamp(col, 0, backend.get_line(line).length())
	if caret_wrap == false:
		backend.set_caret_line(line)
		backend.set_caret_column(col)
	if caret_wrap == true:
		backend.set_caret_line(line)
		backend.set_caret_column(col + wrap_amount)

	syncing_frontend = false
	syncing_backend = false

func copy_selection_to_clipboard(is_cut: bool = false):
	if not backend.has_selection():
		return
	internal_clipboard.clear()
	DisplayServer.clipboard_set("")

	# Determine start/end row indices from selection
	var from_line = backend.get_selection_from_line()
	var from_col  = backend.get_selection_from_column()
	var to_line   = backend.get_selection_to_line()
	var to_col    = backend.get_selection_to_column()

	var start_index = get_absolute_index(from_line, from_col)
	var end_index   = get_absolute_index(to_line, to_col)
	if end_index < start_index:
		var tmp = start_index
		start_index = end_index
		end_index = tmp

	var rows_to_remove := []

	for i in range(text_data.size()):
		# Each row counts as 1 unit
		if i >= start_index and i < end_index:
			internal_clipboard.append(text_data[i].duplicate(true))
			if is_cut:
				rows_to_remove.append(i)

	# Remove rows if cutting
	if is_cut:
		for j in range(rows_to_remove.size() - 1, -1, -1):
			text_data.remove_at(rows_to_remove[j])

	
	update_display()
	update_backend(false)
	

	
func paste_from_clipboard():
	var check = DisplayServer.clipboard_get()
	
	if check != "":
		print("Converting clipboard string...")
		for a in range(check.length()):
			internal_clipboard.append({ "type": "text", "text": check[a], "color": Picker.get_pick_color()})
	
	if internal_clipboard.size() == 0:
		return

	var caret_index = get_absolute_index(backend.get_caret_line(), backend.get_caret_column())
	
	for row in internal_clipboard:
		var copy_row = row.duplicate(true)
		text_data.insert(caret_index, copy_row)
		caret_index += 1  # move caret forward one row per symbol/image

	update_display()
	update_backend(true)
	

func on_Picker_color_changed(color: Color):
	if not backend.has_selection():
		return
	
	var from_line = backend.get_selection_from_line()
	var from_col = backend.get_selection_from_column()
	var to_line = backend.get_selection_to_line()
	var to_col = backend.get_selection_to_column()

	var start_index = get_absolute_index(from_line, from_col)
	var end_index = get_absolute_index(to_line, to_col)
	if end_index < start_index:
		var tmp = start_index
		start_index = end_index
		end_index = tmp
		
	var total = 0
	for i in range(text_data.size()):
		var row = text_data[i]
		var t = row.get("type", "text")
		var length = 0
		
		if t == "text":
			length = row.get("text", "").length()
		elif t == "img":
			length = 1
		else:
			length = 0
		
		var row_start = total
		var row_end = total + length
		
		if row_end >= start_index + 1 and row_start <= end_index - 1:
			if t == "text":
				row.color = color
		
		total += length
		
	update_display()
