extends TextureButton

@export var textEdit:TextEdit;
@export var symbolSize:int = 12;

func _ready():
	pressed.connect(onPressed)
	
	
func onPressed() -> void:
	match texture_normal.resource_path:
		"res://Assets/Images/symbols/star.png":
			symbolSize = 7;
		"res://Assets/Images/symbols/textbubble.png":
			symbolSize = 12;
		"res://Assets/Images/symbols/heart.png":
			symbolSize = 11;
		_: # If it's anything else - being the emojis.
			symbolSize = 10;
	
	textEdit.text += "[img=" + str(symbolSize) + "]"  + texture_normal.resource_path + "[/img] ";
	get_parent().get_parent().onTextboxEditChanged();
