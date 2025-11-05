extends Button

@export var textEdit:TextEdit;
@export var Unicode:String
# Called when the node enters the scene tree for the first time.
@export var Picker: ColorPickerButton

func OnUnicodePressed():
	textEdit.text += Unicode
	get_parent().get_parent().onTextboxEditChanged();

	$"../../WYSIWYG".text_data.append({ "type": "text", "text": Unicode, "color": Picker.get_pick_color() })
	$"../../WYSIWYG".update_display()
	$"../../WYSIWYG".update_backend()
