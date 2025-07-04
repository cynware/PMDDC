extends TextureButton


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_settings_pressed():
	get_node("SettingsMenu").visible = true
	
func _on_close_btn_pressed():
	get_node("SettingsMenu").visible = false
