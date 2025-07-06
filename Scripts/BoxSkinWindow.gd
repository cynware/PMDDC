extends Control


func _ready():
	CheckAndCreateBoxSkinFolder();
	
func CheckAndCreateBoxSkinFolder():
	if (!DirAccess.dir_exists_absolute("user://BoxSkins")):
		DirAccess.make_dir_absolute("user://BoxSkins")
		DirAccess.make_dir_absolute("user://BoxSkins/Template")
		
		#for img in presetImages:
		#	img.get_image().save_png(ProjectSettings.globalize_path("user://Portraits/Template/" + img.resource_path.get_file()));
		print("MADE BOX SKINS FOLDER")
	else:
		print("BOX SKIN FOLDER ALREADY EXISTS")
