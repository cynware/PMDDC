extends Control

@onready var text_edit = $"../TextboxEdit"
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

func _ready():
	pass
	
func _on_unown_mode_toggle_pressed():
	unown_mode = !unown_mode
	
func _on_textbox_edit_gui_input(event):
	if not unown_mode:
		return

	if event is InputEventKey and event.pressed and not event.echo:
		var char = char(event.unicode)
		var upper_char = char.to_upper()

		if upper_char in map.keys():
			text_edit.insert_text_at_caret(map[upper_char])
			$"../TextboxEdit".accept_event()
