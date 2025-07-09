extends Sprite2D

var dragging = false
var offsetty = Vector2(0,0)

var snap = 3
var focus = false

@onready var player = $MOVESFX
var sound1 = preload("res://Assets/Sounds/Portrait_Move_Shift.ogg")
var sound2 = preload("res://Assets/Sounds/Portrait_Move.ogg")

var timer = 0

func resettimer():
	timer = 15


func _process(delta):
	if dragging:
		var newPos = get_global_mouse_position() - offsetty
		position = Vector2(snapped(newPos.x,snap),snapped(newPos.y,snap))
		
	var pos = position
	var screen_size = get_viewport_rect().size
	var portrait_size = $".".get_texture().get_size() / 2
	
	pos.x = clamp(pos.x, portrait_size.y, screen_size.x - portrait_size.x)
	pos.y = clamp(pos.y, portrait_size.y, screen_size.y - portrait_size .y)
	position = pos
	
	if focus == true:
		if Input.is_action_just_pressed("PORTRAIT_LEFT"):
			hideArrows()
			$PortraitHoverButton/ARROWLEFT.visible = true
		if Input.is_action_just_pressed("PORTRAIT_RIGHT"):
			hideArrows()
			$PortraitHoverButton/ARROWRIGHT.visible = true
		if Input.is_action_just_pressed("PORTRAIT_UP"):
			hideArrows()
			$PortraitHoverButton/ARROWUP.visible = true
		if Input.is_action_just_pressed("PORTRAIT_DOWN"):
			hideArrows()
			$PortraitHoverButton/ARROWDOWN.visible = true
# CONTROLS FOR MOVEMENT
		if Input.is_action_just_pressed("PORTRAIT_LEFT"):
			if Input.is_key_pressed(KEY_SHIFT):
				player.stream = sound1
				$".".position.x -= 12
				player.play()
			else:
				player.stream = sound2
				$".".position.x -= 3
				player.play()
		if Input.is_action_just_pressed("PORTRAIT_UP"):
			if Input.is_key_pressed(KEY_SHIFT):
				player.stream = sound1
				$".".position.y -= 12
				player.play()
			else:
				player.stream = sound2
				$".".position.y -= 3
				player.play()
		if Input.is_action_just_pressed("PORTRAIT_RIGHT"):
			if Input.is_key_pressed(KEY_SHIFT):
				player.stream = sound1
				$".".position.x += 12
				player.play()
			else:
				player.stream = sound2
				$".".position.x += 3
				player.play()
		if Input.is_action_just_pressed("PORTRAIT_DOWN"):
			if Input.is_key_pressed(KEY_SHIFT):
				player.stream = sound1
				$".".position.y += 12
				player.play()
			else:
				player.stream = sound2
				$".".position.y += 3
				player.play()

	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var mouse_pos = get_viewport().get_mouse_position()
		# Check if the mouse click was outside the button's rect
		if not $PortraitHoverButton.get_global_rect().has_point(mouse_pos):
			$PortraitHoverButton.release_focus()
			_on_portrait_hover_button_focus_exited()
		
func _on_button_button_down():
	dragging = true
	offsetty = get_global_mouse_position() - global_position

func _on_button_button_up():
	dragging = false

func hideArrows():
	$PortraitHoverButton/ARROWLEFT.visible = false
	$PortraitHoverButton/ARROWRIGHT.visible = false
	$PortraitHoverButton/ARROWUP.visible = false
	$PortraitHoverButton/ARROWDOWN.visible = false

func _on_portrait_hover_button_focus_entered():
	$PortraitHoverButton/PortraitSelection.visible = true
	$PortraitHoverButton/PortraitSelection.play("Selection")
	focus = true


func _on_portrait_hover_button_focus_exited():
	$PortraitHoverButton/PortraitSelection.visible = false
	$PortraitHoverButton/PortraitSelection.play("")
	focus = false
	hideArrows()

var konami_code = [
	"PORTRAIT_UP", "PORTRAIT_UP",
	"PORTRAIT_DOWN", "PORTRAIT_DOWN",
	"PORTRAIT_LEFT", "PORTRAIT_RIGHT",
	"PORTRAIT_LEFT", "PORTRAIT_RIGHT",
	"B", "A", "START"
]

var input_sequence = []

func _unhandled_input(event):
	if event is InputEventKey and event.pressed and not event.echo:
		for action in konami_code:
			if focus == true:
				if Input.is_action_pressed(action) and InputMap.event_is_action(event, action):
					input_sequence.append(action)
					if input_sequence.size() > konami_code.size():
						input_sequence.pop_front()
					break

		if input_sequence == konami_code:
			SuperAwesomeSecretCode()
			input_sequence.clear()

func SuperAwesomeSecretCode():
	$MOVESFX/FANFARE.play()
	$"../SECRET".play("SECRET")
	$"../SECRET".visible = true
	print("Please don't tell Bog")

func _on_fanfare_finished():
	$"../SECRET".visible = false
