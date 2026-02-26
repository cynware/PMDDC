extends Control

@export var PortraitNotice:Array[Texture2D]
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func randomicon():
	PortraitNotice.shuffle()
	$InfoBorder/InfoPortraitBorder/InfoPortrait.texture = PortraitNotice[0]
