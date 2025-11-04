extends TextureButton

@export var textEdit:TextEdit;
@export var symbolSize:int = 12;

var presetedit = false

func _ready():
	pressed.connect(onPressed)
	focus_mode = Control.FOCUS_NONE
	

func onPressed() -> void:
	var texture = load(texture_normal.resource_path)
	var image = texture.get_image()
	var width = image.get_width()
	print(width)
	symbolSize = width
	
	var prefix_edit = $"../../PrefixEdit"
	if prefix_edit.has_focus():
		$"../..".onPrefixEditChanged("[img=" + str(symbolSize) + "]"  + texture_normal.resource_path + "[/img] ")
		$"../../PrefixEdit".text = "[img=" + str(symbolSize) + "]"  + texture_normal.resource_path + "[/img] "
		$"../../PrefixEdit".insert_text_at_caret()
	else:
		$"../../WYSIWYG".text_data.append({"type": "img", "src": texture_normal.resource_path, "size": symbolSize})
		$"../../WYSIWYG".update_display()
		$"../../WYSIWYG".update_backend()
