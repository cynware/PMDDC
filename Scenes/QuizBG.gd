extends SubViewportContainer

var frame_count := 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	frame_count += 1
	if frame_count % 2 == 0:
		$QuizViewport/Layer_1.position.x += 1
		$QuizViewport/Layer_2.position.x -= 1
		# print($QuizViewport/Layer_1.position.x)
	if $QuizViewport/Layer_1.position.x >= 192:
		$QuizViewport/Layer_1.position.x = -192
		$QuizViewport/Layer_2.position.x = 192
