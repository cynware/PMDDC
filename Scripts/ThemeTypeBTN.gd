extends TextureButton

@export var unavailableMark:TextureRect;
func MarkAsUnavailable():
	tooltip_text = "Unavailable. Missing directory, box file or icon file."
	disabled = true;
	unavailableMark.visible = true;
	
func MarkAsAvailable():
	tooltip_text = "";
	disabled = false;
	unavailableMark.visible = false;	
	
