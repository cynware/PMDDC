extends Button

@export var textEdit:TextEdit;
@export var Unicode:String
# Called when the node enters the scene tree for the first time.


func OnUnicodePressed():
	textEdit.text += Unicode
	get_parent().get_parent().onTextboxEditChanged();
