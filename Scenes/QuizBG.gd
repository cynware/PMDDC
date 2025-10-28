extends SubViewportContainer

var speed := 30.0 # pixels per second

func _process(delta):
	$QuizViewport/Layer_1.position.x += speed * delta
	$QuizViewport/Layer_2.position.x -= speed * delta

	if $QuizViewport/Layer_1.position.x >= 192:
		$QuizViewport/Layer_1.position.x = -192
		$QuizViewport/Layer_2.position.x = 192

