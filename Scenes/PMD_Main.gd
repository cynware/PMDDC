extends Node2D

@export var text_display_1: RichTextLabel
@export var text_display_2: RichTextLabel

var scroll_speed = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_play_btn_pressed():
	var text_data = $"../PMD_Debug/DebugTab/Tabs/DialogueTab/WYSIWYG".text_data
	var prefixlength = $"../PMD_Debug/DebugTab/Tabs/DialogueTab".prefix.length() + 2
	var length = 0
	
	if text_data == []:
		return
	if $"../PMD_Debug/DebugTab/Tabs/DialogueTab".prefixEnabled.button_pressed:
		length = text_display_1.get_total_character_count() - prefixlength
		text_display_1.visible_characters = prefixlength
	else:
		length = text_display_1.get_total_character_count()
		text_display_1.visible_characters = 0
	$"../PlayBTN".disabled = true
	$"../PMD_Debug/DebugTab/Tabs/DialogueTab/WYSIWYG".syncing_frontend = true
	
	text_display_2.visible_characters = text_display_1.visible_characters
	for i in length:
		text_display_1.visible_characters += 1
		if i % 3 == 0:
			SoundEffectManager.PlayType()
		var speed_idx = text_data[i].get("scroll_speed")
		match speed_idx:
			1:
				scroll_speed = 7.0 / 60.0
			2:
				scroll_speed = 2.0 / 60.0
			3:
				scroll_speed = 1.0 / 60.0
		text_display_2.visible_characters = text_display_1.visible_characters
		await get_tree().create_timer(scroll_speed).timeout
		if text_display_1.visible_characters == text_display_1.get_total_character_count():
			text_display_1.visible_characters = -1
			$"../PlayBTN".disabled = false
			text_display_2.visible_characters = text_display_1.visible_characters
			await get_tree().create_timer(0.3).timeout
			$"../PMD_Debug/DebugTab/Tabs/DialogueTab/WYSIWYG".syncing_frontend = false
