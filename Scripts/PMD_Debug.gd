extends Node2D

var initialPosition:Vector2;
var lerpPosition:Vector2;
var isVisible:bool = true;

func _ready():
	initialPosition = self.position;
	
func _process(delta):
	position = lerp(position, lerpPosition, 15 * delta);
	
	if(Input.is_action_just_pressed("TOGGLE_DEBUG")):
		isVisible = !isVisible;
		
		if(isVisible):
			lerpPosition = initialPosition
		else:
			lerpPosition = initialPosition + Vector2.RIGHT * 800;
