extends Control
@export var OptionBoxBorder: NinePatchRect
@export var OptionBox: Control

@export var OptionLabel1: LineEdit
@export var OptionLabel2: LineEdit
@export var OptionLabel3: LineEdit
@export var OptionLabel4: LineEdit
@export var OptionLabel5: LineEdit
var OptionLabels = []

@export var BoxLine1: RichTextLabel
@export var BoxLine2: RichTextLabel
@export var BoxLine3: RichTextLabel
@export var BoxLine4: RichTextLabel
@export var BoxLine5: RichTextLabel
var BoxLines = []

@export var BoxLineS1: RichTextLabel
@export var BoxLineS2: RichTextLabel
@export var BoxLineS3: RichTextLabel
@export var BoxLineS4: RichTextLabel
@export var BoxLineS5: RichTextLabel
var BoxLineShadows = []

@export var TextOffset: SpinBox
@export var BoxPadding: SpinBox

var padding = Vector2(36,15)

@export var OptMarker1: TextureButton
@export var OptMarker2: TextureButton
@export var OptMarker3: TextureButton
@export var OptMarker4: TextureButton
@export var OptMarker5: TextureButton
var OptMarkers = []
var MarkedOption = 0

var TheMagicBoxFixerVector = Vector2(0,0)

@export var OptionArrow: TextureRect
@export var HighlightMarker: ColorRect
@export var HighlightButton: Button

# Called when the node enters the scene tree for the first time.
func _ready():
	OptionLabels = [
		OptionLabel1,
		OptionLabel2,
		OptionLabel3,
		OptionLabel4,
		OptionLabel5
	]
	
	BoxLines = [
		BoxLine1,
		BoxLine2,
		BoxLine3,
		BoxLine4,
		BoxLine5
	]
	
	BoxLineShadows = [
		BoxLineS1,
		BoxLineS2,
		BoxLineS3,
		BoxLineS4,
		BoxLineS5
	]
	
	OptMarkers = [
		OptMarker1,
		OptMarker2,
		OptMarker3,
		OptMarker4,
		OptMarker5
	]
	

func _on_option_label_text_changed(new_text):
	var FilledBoxes = 0
	var max_width = 0
	var total_height = 0
	var LastFilled = 0
	
	OptionArrow.position.x = 9
	HighlightMarker.position.x = 8
		
	for i in range(OptionLabels.size()):
		BoxLineShadows[i].text = OptionLabels[i].text
		BoxLines[i].text = OptionLabels[i].text
		BoxLineShadows[i].reset_size()
		BoxLines[i].reset_size()
		if OptionLabels[i].text != "":
			FilledBoxes += 1
			LastFilled = i + 1
			max_width = max(max_width, BoxLines[i].get_content_width())
			total_height = BoxLines[i].get_content_height() * LastFilled
	
	#print("Filledboxes: ", FilledBoxes, " | max width :", max_width, " | total height: ", total_height, " | Last filled: ", LastFilled)
	
	# default value for zero filled boxes so all hell doesnt break loose with the positioning LMAO
	if FilledBoxes == 0:
		max_width = 4
		total_height = 13
	
	var box_padx = 0
	var box_pady = 0
	match FilledBoxes:
		1:
			#print("Wow!")
			TheMagicBoxFixerVector = Vector2(padding.x / 2 + TextOffset.value, padding.y / 2 - 2)
			box_padx = 0
			box_pady = 0
		2:
			#print("This code won't be pretty!")
			TheMagicBoxFixerVector = Vector2(padding.x / 2 + TextOffset.value, padding.y / 2 - 1)
			box_padx = 0
			box_pady = 3
		3:
			#print("but who can blame me!")
			TheMagicBoxFixerVector = Vector2(padding.x / 2 + TextOffset.value, padding.y / 2 - 0)
			box_padx = 0
			box_pady = 6
		4:
			#print("pmd is held together like the code of undertale")
			TheMagicBoxFixerVector = Vector2(padding.x / 2 + TextOffset.value, padding.y / 2 - 3)
			box_padx = 0
			box_pady = 1
		5:
			#print("and i am NOT kidding")
			TheMagicBoxFixerVector = Vector2(padding.x / 2 + TextOffset.value, padding.y / 2 - 1)
			box_pady = 5
	
	var text_size = Vector2(max_width + BoxPadding.value, total_height + box_pady)
	var new_size = text_size + padding
	
	var diff = new_size - OptionBoxBorder.size
	OptionBoxBorder.size = new_size
	OptionBoxBorder.position -= Vector2(diff.x, diff.y)
	
	for i in range(BoxLines.size()):
		BoxLines[i].position = TheMagicBoxFixerVector + Vector2(0, i * 14)
		
	# If the field is empty, don't fuckin give you the option to press the corrosponding marker
	for i in range(OptMarkers.size()):
		if OptionLabels[i].text == "":
			OptMarkers[i].disabled = true
			OptMarkers[i].button_pressed = false
		else:
			OptMarkers[i].disabled = false
	
	MarkerPosSwitch()

func _on_box_toggle_toggled(toggled_on):
	if toggled_on:
		OptionBox.visible = true
		SoundEffectManager.PlayCheckboxOn()
	else:
		OptionBox.visible = false
		SoundEffectManager.PlayCheckboxOff()


func _on_marker_toggled(toggled_on):
	if toggled_on:
		SoundEffectManager.PlayAccept()
		OptionArrow.visible = true
	else:
		OptionArrow.visible = false
	MarkerPosSwitch()


func MarkerPosSwitch():
	for i in range(OptMarkers.size()):
		if OptMarkers[i].button_pressed == true:
			MarkedOption = i
	print(MarkedOption)
	print("OptionArrow Y : ",OptionArrow.position.y)
	print("Box Line Y : ",BoxLines[MarkedOption].position.y)
	for i in range(BoxLines.size()):
		OptionArrow.position.y = BoxLines[MarkedOption].position.y + 1
		HighlightMarker.position.y = OptionArrow.position.y
		HighlightMarker.size.x = OptionBoxBorder.size.x - 16
		if BoxLines[MarkedOption].text == "":
			HighlightMarker.visible = false
			OptionArrow.visible = false
			HighlightButton.button_pressed = false
			HighlightButton.disabled = true
		else:
			HighlightButton.disabled = false
	
func _on_close_btn_pressed():
	$".".visible = false;
	SoundEffectManager.PlayCancel();


func on_highlight_toggle(toggled_on):
	if BoxLines[MarkedOption].text != "":
		if toggled_on:
			HighlightMarker.visible = true
		else:
			HighlightMarker.visible = false
