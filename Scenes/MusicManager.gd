extends Control
@export var MusicLabel: RichTextLabel

# Called when the node enters the scene tree for the first time.
var AudioURL = ""
var CreditURL = ""

var rng = RandomNumberGenerator.new()
var cursong: int
var nextsong = rng.randi_range(0, 1)
var fadepoint: int

var FADING = true
func _ready():
	_on_ost_finished()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if FADING == true:
		if $OST.get_playback_position() >= fadepoint:
			if $OST.volume_db > -80:
				$OST.volume_db -= 15*delta
		elif $OST.volume_db < -20:
			$OST.volume_db += 15*delta
			
	elif $OST.volume_db < -20:
		$OST.volume_db += 15*delta

func _on_musiclabel_meta_clicked(meta):
	OS.shell_open(meta)


func _on_ost_finished():
	cursong = nextsong
	match cursong:
		0: # Writing's a Mystery
			$OST.stream = load("res://Assets/Sounds/OST_NOONEDOESSTUFF.wav")
			AudioURL = "[url=https://www.youtube.com/watch?v=37y3paKB84E] - Writing's a Mystery[/url]"
			CreditURL = "[url=https://www.youtube.com/@noonedoesstuff][color=f8f800](NoOneDoesStuff)[/color][/url]"
			MusicLabel.text = "[center][img=12]res://Scenes/EditorState.tscn::AnimatedTexture_lqy4g[/img]" + AudioURL + "\n" + CreditURL + "[/center]"
			fadepoint = 153
		1: # Revision
			$OST.stream = load("res://Assets/Sounds/OST_PARTWAYS.wav")
			AudioURL = "[url=https://soundcloud.com/parpmd2/partways-pick-your-part/s-Q4zrdWLPeLY] - Write Your Part![/url]"
			CreditURL = "[url=https://soundcloud.com/parpmd2/tracks][color=f8f800](Partways)[/color][/url]"
			MusicLabel.text = "[center][img=12]res://Scenes/EditorState.tscn::AnimatedTexture_lqy4g[/img]" + AudioURL + "\n" + CreditURL + "[/center]"
			fadepoint = 113
			
	nextsong = rng.randi_range(0, 1)
	if cursong != nextsong:
		FADING = true
	else:
		FADING = false
	$OST.playing = true
	print("CURRENT SONG: " + str(cursong) + " | FADING: " + str(FADING))
