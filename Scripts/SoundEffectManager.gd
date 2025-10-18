extends Node

@export var sfx_accept:AudioStreamPlayer;
@export var sfx_cancel:AudioStreamPlayer;

@export var sfx_checkboxOn:AudioStreamPlayer;
@export var sfx_checkboxOff:AudioStreamPlayer;

@export var sfx_chooseDropdown:AudioStreamPlayer;
@export var sfx_delete:AudioStreamPlayer;
@export var sfx_savePreset:AudioStreamPlayer;

@export var sfx_folderBTN:AudioStreamPlayer;
@export var sfx_refreshBTN:AudioStreamPlayer;

@export var sfx_Type:AudioStreamPlayer;
@export var sfx_TypeBackspace:AudioStreamPlayer;

@export var sfx_BGImport:AudioStreamPlayer;

@export var sfx_Error:AudioStreamPlayer;

@export var sfx_Move:AudioStreamPlayer;
@export var sfx_Fanfare:AudioStreamPlayer;

@export var sfx_Settings:AudioStreamPlayer;
@export var sfx_Mute:AudioStreamPlayer;

@export var sfx_tab_dialogue:AudioStreamPlayer;
@export var sfx_tab_portraits:AudioStreamPlayer;
@export var sfx_tab_presets:AudioStreamPlayer;


func PlayAccept():
	sfx_accept.play()
	
func PlayDialogueTab():
	sfx_tab_dialogue.play()
func PlayPortraitTab():
	sfx_tab_portraits.play()
func PlayPresetTab():
	sfx_tab_presets.play()
	
func PlaySetting():
	sfx_Settings.pitch_scale = randf_range(0.8, 0.95)
	sfx_Settings.play()
	
func PlayMute():
	sfx_Mute.play()

func PlayMove():
	sfx_Move.play()

func PlayFanfare():
	sfx_Fanfare.play()

func PlayError():
	sfx_Error.play()

func PlayBGImport():
	sfx_BGImport.play()
	
func PlayFolder():
	sfx_folderBTN.pitch_scale = randf_range(0.95, 1.05)
	sfx_folderBTN.play()
	
func PlayRefresh():
	sfx_refreshBTN.pitch_scale = randf_range(0.95, 1.05)
	sfx_refreshBTN.play()
	
func PlayType():
	sfx_Type.play()
func PlayTypeback():
	sfx_TypeBackspace.play()
	
func PlayCancel():
	sfx_cancel.play()
	
func PlayCheckboxOn():
	sfx_checkboxOn.play()

func PlayCheckboxOff():
	sfx_checkboxOff.play()

func PlayChooseDropdown():
	sfx_chooseDropdown.play()
	
func PlayDelete():
	sfx_delete.play()

func PlaySavePreset():
	sfx_savePreset.play()
