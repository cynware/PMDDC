extends TextureButton

@export var textEdit:TextEdit;
@export var symbolSize:int = 12;

func _ready():
	pressed.connect(onPressed)
	
	
func onPressed() -> void:
	match texture_normal.resource_path:
		"res://Assets/Images/symbols/star.png":
			symbolSize = 7;
		"res://Assets/Images/symbols/textbubble.png", "res://Assets/Images/symbols/UI_dpad.png":
			symbolSize = 12;
		"res://Assets/Images/symbols/heart.png", "res://Assets/Images/symbols/orb.png", "res://Assets/Images/symbols/tm.png", "res://Assets/Images/symbols/UI_l.png", "res://Assets/Images/symbols/UI_r.png":
			symbolSize = 11;
		"res://Assets/Images/symbols/UI_a.png", "res://Assets/Images/symbols/UI_b.png", "res://Assets/Images/symbols/UI_x.png", "res://Assets/Images/symbols/UI_y.png":
			symbolSize = 11;
		"res://Assets/Images/symbols/tick.png", "res://Assets/Images/symbols/cross.png":
			symbolSize = 8;
		"res://Assets/Images/symbols/UI_start.png", "res://Assets/Images/symbols/UI_select.png":
			symbolSize = 22;
		_: # If it's anything else - being the emojis.
			symbolSize = 10;
	
	textEdit.text += "[img=" + str(symbolSize) + "]"  + texture_normal.resource_path + "[/img] ";
	get_parent().get_parent().onTextboxEditChanged();
