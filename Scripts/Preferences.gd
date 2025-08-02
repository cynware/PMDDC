extends Node

var export_ResolutionMultiplier:int;
var export_transparentBackground:bool;

var audio_masterVolume:float = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"));
var audio_musicVolume:float = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music"));
var audio_sfxVolume:float = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Sound"))

func _ready():
	GetAndUpdatePreferencesFromFile()
	

func SavePreferences():
	var prefs := {
		"export_ResolutionMultiplier": export_ResolutionMultiplier,
		"export_transparentBackground": export_transparentBackground,
		"audio_masterVolume": audio_masterVolume,
		"audio_musicVolume": audio_musicVolume,
		"audio_sfxVolume": audio_sfxVolume
	}
	
	var json = JSON.stringify(prefs);
	print(json)
	
	var savePath = "user://Preferences.json"
	var file = FileAccess.open(savePath, FileAccess.WRITE);
	
	if file:
		file.store_string(json);
		file.close();
	else:
		print("Failed to save preferences to file at path: " + savePath);

func GetAndUpdatePreferencesFromFile() -> Dictionary:
	var savePath = "user://Preferences.json"
	var file = FileAccess.open(savePath, FileAccess.READ);
	var prefDictionary:Dictionary;
	
	if file:
		prefDictionary = JSON.parse_string(file.get_as_text());
		
		export_ResolutionMultiplier = prefDictionary["export_ResolutionMultiplier"]
		export_transparentBackground = prefDictionary["export_transparentBackground"]
		
		audio_masterVolume = prefDictionary["audio_masterVolume"]
		audio_musicVolume = prefDictionary["audio_musicVolume"]
		audio_sfxVolume = prefDictionary["audio_sfxVolume"]
	
		file.close();
	else:
		print("Failed to read preferences from file at path: " + savePath);

	
	print(prefDictionary)
	return prefDictionary
