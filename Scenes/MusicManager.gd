extends Control
@export var MusicLabel: RichTextLabel
# Called when the node enters the scene tree for the first time.
var AudioURL = ""
var CreditURL = ""
func _ready():
	on_mus_change()

func on_mus_change():
	AudioURL = "[url=https://www.youtube.com/watch?v=dQw4w9WgXcQ] - Writing's a Mystery[/url]"
	CreditURL = "[url=https://www.youtube.com/@noonedoesstuff][color=f8f800](NoOneDoesStuff)[/color][/url]"
	MusicLabel.text = "[center][img=12]res://Scenes/EditorState.tscn::AnimatedTexture_lqy4g[/img]" + AudioURL + "\n" + CreditURL + "[/center]"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_musiclabel_meta_clicked(meta):
	OS.shell_open(meta)
