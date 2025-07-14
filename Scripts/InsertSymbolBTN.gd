extends TextureButton

@export var textEdit:TextEdit;
@export var symbolSize:int = 12;

func _ready():
	pressed.connect(onPressed)
	
	
func onPressed() -> void:
	var texture = load(texture_normal.resource_path)
	var image = texture.get_image()
	var width = image.get_width()
	print(width)
	symbolSize = width
	
	textEdit.text += "[img=" + str(symbolSize) + "]"  + texture_normal.resource_path + "[/img] ";
	get_parent().get_parent().onTextboxEditChanged();
