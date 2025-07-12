extends Control

@export var textboxText:RichTextLabel
@export var textboxText2:RichTextLabel

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
	Color("F8F800"),
	Color("0098F8"),
	Color(0, 152, 248, 1),
	Color(0, 255, 0, 1)
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
	
func onTextboxEditChanged():
	sentence = $TextboxEdit.text
	updateHUD()

func onPrefixEditChanged(new_text):	
	prefix = new_text
	
	updateHUD();

func updateHUD() -> void:
	
	if prefixEnabled.button_pressed:
		textboxText.text = "[" + Alignment + "]" + "[color=" + str(prefixColour.to_html(false)) + "]" + prefix + "[/color][img=3]res://Assets/Images/prefixcolon.png[/img] " + sentence  + "[/" + Alignment + "]";
		textboxText2.text = "[" + Alignment + "]" + "[color=" + str(prefixColour.to_html(false)) + "]" + prefix + "[/color][img=3]res://Assets/Images/prefixcolon.png[/img] " + sentence  + "[/" + Alignment + "]";
	else:
		textboxText.text = "[" + Alignment + "]" + sentence + "[/" + Alignment + "]"
		textboxText2.text = "[" + Alignment + "]" + sentence + "[/" + Alignment + "]"
	
func onColourInsert():
	$TextboxEdit.text += "[color=" + str(textboxInsertColourPicker.get_picker().color.to_html(false)) + "]TEXT[/color]"; 
	sentence = $TextboxEdit.text
	updateHUD();
	
func _on_prefix_enabled_pressed():
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
	$ClickSFX.play();

func onSymbolWindowOpen():
	$SymbolWindow.visible = true;
	$ClickSFX.play();
	
func onGlyphWindowOpen():
	$UnicodeWindow.visible = true
	$ClickSFX.play();

func _on_alignment_button_item_selected(index):
	match index:
		0:
			Alignment = "left"
		1:
			Alignment = "center"
		2:
			Alignment = "right"
	updateHUD();
	print(Alignment)

