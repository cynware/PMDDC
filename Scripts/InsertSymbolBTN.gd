extends TextureButton

@export var textEdit:TextEdit;
@export var symbolSize:int = 10;

func _ready():
	pressed.connect(onPressed)
	
func onPressed() -> void:
	textEdit.text += "[img=" + str(symbolSize) + "]"  + texture_normal.resource_path + "[/img] ";
	get_parent().get_parent().onTextboxEditChanged();
