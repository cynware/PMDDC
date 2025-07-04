extends Node2D

@export var cursorTexture:Texture2D;
@export var cursorBeam:Texture2D;

func _ready():
	Input.set_custom_mouse_cursor(cursorTexture)
	Input.set_custom_mouse_cursor(cursorBeam, Input.CURSOR_IBEAM)
