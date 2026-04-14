extends Control

@export var textboxText:RichTextLabel
@export var textboxText2:RichTextLabel
var rng = RandomNumberGenerator.new()

@onready var textboxEdit:TextEdit = $TextboxEdit
@onready var textboxInsertColourPicker:ColorPickerButton = $InsertColour;

@onready var prefixEdit:LineEdit = $PrefixEdit
@onready var prefixColourPicker:ColorPickerButton = $PrefixColour;
@onready var prefixEnabled:CheckBox = $PrefixEnabled;

var sentence:String = "Blah blah blah...";
var prefix:String = "???";
var prefixColour:Color = Color("F8F800");

var Alignment = "left"

var colorSwatches:Array[Color] = [
	Color(Color.WHITE),
	Color("F8F800"),
	Color("0098F8"),
	Color("00ffff"),
	Color("00ff00")
]

func _ready():
	textboxEdit.text = sentence;
	prefixEdit.text = prefix;
	
	prefixColourPicker.get_picker().can_add_swatches = false;
	prefixColour = prefixColourPicker.color;
	#textbox.prefixColor = str(prefixColourPicker.get_picker().color.to_html(false));
	
	for i in range(colorSwatches.size()):
		prefixColourPicker.get_picker().add_preset(colorSwatches[i]);
		textboxInsertColourPicker.get_picker().add_preset(colorSwatches[i]);
	
	updateHUD();
	
	var secretdoof = round(rng.randf_range(1, 100))
	if secretdoof == 50:
		$InsertColour/SecretDoof.visible = true
		$InsertColour/SecretDoof/SecretDoof.play("default")
		$WYSIWYG/Backend_Editor.placeholder_text = "Aw, look! He's sleeping!"
	else:
		$InsertColour/SecretDoof.visible = false
	
	
	
func onTextboxEditChanged():
	sentence = $TextboxEdit.text
	updateHUD()
	if not Input.is_key_pressed(KEY_SPACE) and not Input.is_key_pressed(KEY_ENTER):
		if Input.is_key_pressed(KEY_BACKSPACE):
			SoundEffectManager.PlayTypeback()
		else:
			SoundEffectManager.PlayType()

func onPrefixEditChanged(new_text):	
	prefix = new_text
	
	updateHUD();

func updateHUD() -> void:
	
	if prefixEnabled.button_pressed:
		textboxText.text = "[" + Alignment + "]" + "[color=" + str(prefixColour.to_html(false)) + "]" + prefix + "[/color][img=3]res://Assets/Images/prefixcolon.png[/img] " + $WYSIWYG.boxstorage.text  + "[/" + Alignment + "]";
		textboxText2.text = "[" + Alignment + "]" + "[color=" + str(prefixColour.to_html(false)) + "]" + prefix + "[/color][img=3]res://Assets/Images/prefixcolon.png[/img] " + $WYSIWYG.boxstorage.text  + "[/" + Alignment + "]";
	else:
		textboxText.text = "[" + Alignment + "]" + $WYSIWYG.boxstorage.text + "[/" + Alignment + "]"
		textboxText2.text = "[" + Alignment + "]" + $WYSIWYG.boxstorage.text + "[/" + Alignment + "]"
	
func onColourInsert():
	$TextboxEdit.text += "[color=" + str(textboxInsertColourPicker.get_picker().color.to_html(false)) + "]TEXT[/color]"; 
	sentence = $TextboxEdit.text
	updateHUD();
	
func _on_prefix_enabled_pressed():
	if prefixEnabled.button_pressed:
		SoundEffectManager.PlayCheckboxOn()
	else:
		SoundEffectManager.PlayCheckboxOff()
	updateHUD();
	
func onPrefixColourChanged(colour):
	prefixColour = colour;
	updateHUD();
	
########################################################
################[SYMBOL INSERT STUFF]###################
########################################################



func onSymbolWindowClose():
	$SymbolWindow.visible = false;
	$UnicodeWindow.visible = false;
	SoundEffectManager.PlayCancel()

func onSymbolWindowOpen():
	$SymbolWindow.visible = true;
	SoundEffectManager.PlayAccept()
	
func onGlyphWindowOpen():
	$UnicodeWindow.visible = true
	SoundEffectManager.PlayAccept()

func onOptionBoxWindowOpen():
	$OptionBoxWindow.visible = true
	SoundEffectManager.PlayAccept()

func _on_alignment_button_item_selected(index):
	SoundEffectManager.PlayChooseDropdown()
	match index:
		0:
			Alignment = "left"
		1:
			Alignment = "center"
		2:
			Alignment = "right"
	updateHUD();
	print(Alignment)

func _input(event):
	if(Input.is_action_just_pressed("BACK")):
		if($SymbolWindow.visible or $UnicodeWindow.visible):
			onSymbolWindowClose()
			
