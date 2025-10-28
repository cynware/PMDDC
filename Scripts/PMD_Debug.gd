extends Node2D

var initialPosition:Vector2;
var lerpPosition:Vector2;
var isVisible:bool = true;

func _ready():
	initialPosition = self.position;
	
func _process(delta):
	position = lerp(position, lerpPosition, 15 * delta);
	
	if(Input.is_action_just_pressed("TOGGLE_DEBUG")):
		isVisible = !isVisible;
		
		if(isVisible):
			lerpPosition = initialPosition
			$"../Save".visible = true
			$"../Settings".visible = true
		else:
			lerpPosition = initialPosition + Vector2.RIGHT * 800;
			$"../Save".visible = false
			$"../Settings".visible = false




func portrait_tab_pressed():
	$DebugTab/Tabs/PortraitTab.visible = true
	$DebugTab/Tabs/DialogueTab.visible = false
	$DebugTab/Tabs/ThemesTab.visible = false
	$DebugTab/Tabs/PresetsTab.visible = false
	$TAB_DISPLAYNAME/Label.text = "PORTRAITS"
	
	$PortraitTAB_BTN/ICON.play("CLICK")
	$ThemesTAB_BTN/ICON.play("IDLE")
	$PresetsTAB_BTN/ICON.play("IDLE")
	$DialogueTAB_BTN/ICON.play("IDLE")
	
	SoundEffectManager.PlayPortraitTab()



func themes_tab_pressed():
	$DebugTab/Tabs/ThemesTab.visible = true
	$DebugTab/Tabs/DialogueTab.visible = false
	$DebugTab/Tabs/PortraitTab.visible = false
	$DebugTab/Tabs/PresetsTab.visible = false
	$TAB_DISPLAYNAME/Label.text = "THEMES"
	
	$ThemesTAB_BTN/ICON.play("CLICK")
	$PortraitTAB_BTN/ICON.play("IDLE")
	$PresetsTAB_BTN/ICON.play("IDLE")
	$DialogueTAB_BTN/ICON.play("IDLE")
	
	SoundEffectManager.PlayBGImport()


func presets_tab_pressed():
	$DebugTab/Tabs/PresetsTab.visible = true
	$DebugTab/Tabs/DialogueTab.visible = false
	$DebugTab/Tabs/ThemesTab.visible = false
	$DebugTab/Tabs/PortraitTab.visible = false
	$TAB_DISPLAYNAME/Label.text = "PRESETS"
	
	$PresetsTAB_BTN/ICON.play("CLICK")
	$DialogueTAB_BTN/ICON.play("IDLE")
	$ThemesTAB_BTN/ICON.play("IDLE")
	$PortraitTAB_BTN/ICON.play("IDLE")
	
	SoundEffectManager.PlayPresetTab()


func dialogue_tab_pressed():
	$DebugTab/Tabs/DialogueTab.visible = true
	$DebugTab/Tabs/ThemesTab.visible = false
	$DebugTab/Tabs/PortraitTab.visible = false
	$DebugTab/Tabs/PresetsTab.visible = false
	$TAB_DISPLAYNAME/Label.text = "DIALOGUE"
	
	$DialogueTAB_BTN/ICON.play("CLICK")
	$PresetsTAB_BTN/ICON.play("IDLE")
	$ThemesTAB_BTN/ICON.play("IDLE")
	$PortraitTAB_BTN/ICON.play("IDLE")
	
	SoundEffectManager.PlayDialogueTab()
