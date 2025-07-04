extends Control


var toggled:bool = true;
func _on_quick_swap_pressed():
	toggled = !toggled;
	
	if toggled:
		$"../../../../PMD_Main/Textbox".texture = load("res://PmdThemes/eos/eosBox_M.png");
		$"../../../../PMD_Main/Portrait".texture = load("res://PmdThemes/eos/eosIcon_M.png");
	else:
		$"../../../../PMD_Main/Textbox".texture = load("res://PmdThemes/eos/eosBox_F.png");
		$"../../../../PMD_Main/Portrait".texture = load("res://PmdThemes/eos/eosIcon_F.png");


func onBgColourInputChanged(color):
	$"../../../../BgColour".color = color;


func _on_change_blue_pressed():
	$"../../../../PMD_Main/Textbox".texture = load("res://PmdThemes/eos/eosBox_M.png");
	$"../../../../PMD_Main/Portrait".texture = load("res://PmdThemes/eos/eosIcon_M.png");


func _on_change_pink_pressed():
	$"../../../../PMD_Main/Textbox".texture = load("res://PmdThemes/eos/eosBox_F.png");
	$"../../../../PMD_Main/Portrait".texture = load("res://PmdThemes/eos/eosIcon_F.png");


func _on_change_green_pressed():
	$"../../../../PMD_Main/Textbox".texture = load("res://PmdThemes/eos/eosBox_NB.png");
	$"../../../../PMD_Main/Portrait".texture = load("res://PmdThemes/eos/eosIcon_NB.png");

func onPortraitWindowClose():
	$PortraitWindow.visible = false;
	$ClickSFX.play();

func onPortraitWindowOpen():
	$PortraitWindow.visible = true;
	$ClickSFX.play();



func on_portrait_flip():
	if $PortraitFlip.button_pressed:
		$"../../../../PMD_Main/Portrait/Icon".scale.x = -1;
	else:
		$"../../../../PMD_Main/Portrait/Icon".scale.x = 1;



func _on_portrait_hide_pressed():
	if $PortraitHide.button_pressed:
		$"../../../../PMD_Main/Portrait".visible = false
	else:
		$"../../../../PMD_Main/Portrait".visible = true
