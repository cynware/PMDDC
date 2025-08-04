extends Button

## The tab it toggles on/off
@export var tab:Control;


var initialY:float;
var lerpY:float;

func _ready() -> void:
	initialY = position.y;
	lerpY = initialY;

func _process(delta):
	position.y = lerp(position.y, lerpY, 15 * delta);
	
func _on_pressed():
	SoundEffectManager.PlayAccept()
	
	for child in $"../DebugTab/Tabs".get_children():
		child.visible = false;
	
	if tab:
		tab.visible = true;

func _on_mouse_entered():
	lerpY = initialY - 5;

func _on_mouse_exited():
	lerpY = initialY;
