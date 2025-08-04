extends Node

@export var sfx_accept:AudioStreamPlayer;
@export var sfx_cancel:AudioStreamPlayer;

@export var sfx_checkboxOn:AudioStreamPlayer;
@export var sfx_checkboxOff:AudioStreamPlayer;

@export var sfx_chooseDropdown:AudioStreamPlayer;
@export var sfx_delete:AudioStreamPlayer;
@export var sfx_savePreset:AudioStreamPlayer;


func PlayAccept():
	sfx_accept.play()
	
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
