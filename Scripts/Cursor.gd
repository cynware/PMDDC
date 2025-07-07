extends Node2D

@export var cursorTexture:Texture2D;
@export var cursorBeam:Texture2D;
@export var cursorHand:Texture2D;
@export var cursorPointer:Texture2D;
@export var cursorGrab:Texture2D;

func _ready():
	Input.set_custom_mouse_cursor(cursorTexture)
	Input.set_custom_mouse_cursor(cursorBeam, Input.CURSOR_IBEAM)
	Input.set_custom_mouse_cursor(cursorPointer, Input.CURSOR_POINTING_HAND)

var current_cursor = null
func _process(delta):
	
	var new_cursor = cursorTexture
	
	for button in get_tree().get_nodes_in_group("UI_BUTTONS"):
		if button.is_hovered():
			new_cursor = cursorPointer
	
	if new_cursor == cursorTexture:
		if $"../PMD_Main/Portrait/PortraitHoverButton".is_pressed():
			new_cursor = cursorGrab
		else: if $"../PMD_Main/Portrait/PortraitHoverButton".is_hovered():
			new_cursor = cursorHand
	
	if new_cursor != current_cursor:
		Input.set_custom_mouse_cursor(new_cursor)
		current_cursor = new_cursor
