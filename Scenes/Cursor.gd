extends Node2D


# Load the custom images for the mouse cursor.
var arrow = load("res://Assets/Images/cursor.png")
var beam = load("res://Assets/Images/cursor_beam.png")


func _ready():
	# Changes only the arrow shape of the cursor.
	# This is similar to changing it in the project settings.
	Input.set_custom_mouse_cursor(arrow)

	# Changes a specific shape of the cursor (here, the I-beam shape).
	Input.set_custom_mouse_cursor(beam, Input.CURSOR_IBEAM)
