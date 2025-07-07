extends Control

@export var skinDropdown:OptionButton;
var loadedSkins:Array[PmdSkinData]
var currentlySelectedSkin:PmdSkinData;

@export var icon:Sprite2D;
@export var box:Sprite2D;

func _ready():
	CheckAndCreateBoxSkinFolder();
	AddInternalSkins()
	
func CheckAndCreateBoxSkinFolder():
	if (!DirAccess.dir_exists_absolute("user://BoxSkins")):
		DirAccess.make_dir_absolute("user://BoxSkins")
		DirAccess.make_dir_absolute("user://BoxSkins/Template")
		
		#for img in presetImages:
		#	img.get_image().save_png(ProjectSettings.globalize_path("user://Portraits/Template/" + img.resource_path.get_file()));
		print("MADE BOX SKINS FOLDER")
	else:
		print("BOX SKIN FOLDER ALREADY EXISTS")
		
# jus the skins that come bundled with PMDDC :>
func AddInternalSkins():
	skinDropdown.clear()
	var InternalThemeDirectories = DirAccess.get_directories_at("res://PmdSkins")
	print("...........INTERNAL SKINS............")
	print(InternalThemeDirectories)
	var i = 0;
	for skin in InternalThemeDirectories:
		var path = "res://PmdSkins/" + skin;
		
		var skinData:PmdSkinData = PmdSkinData.new()
		
		if(DirAccess.dir_exists_absolute(path + "/Male")):
			skinData.male_icon = load(path + "/Male/icon.png");
			skinData.male_box = load(path + "/Male/box.png");
			
		if(DirAccess.dir_exists_absolute(path + "/Female")):
			skinData.female_icon = load(path + "/Female/icon.png");
			skinData.female_box = load(path + "/Female/box.png");
			
		if(DirAccess.dir_exists_absolute(path + "/NonBinary")):	
			skinData.nonbinary_icon = load(path + "/NonBinary/icon.png");
			skinData.nonbinary_box = load(path + "/NonBinary/box.png");
		
		loadedSkins.insert(i, skinData);
		skinDropdown.add_item(skin)
		i += 1;


func OnSkinDropdownItemSelected(index):
	currentlySelectedSkin = loadedSkins[index];
	
	# MALE STUFF
	if(currentlySelectedSkin.male_box != null):
		box.texture = currentlySelectedSkin.male_box;
	if(currentlySelectedSkin.male_icon != null):
		icon.texture = currentlySelectedSkin.male_icon;
	
	if(icon.texture == currentlySelectedSkin.male_icon && box.texture == currentlySelectedSkin.male_box):
		return;
	
	# FEMALE STUFF
	if(currentlySelectedSkin.female_box != null):
		box.texture = currentlySelectedSkin.female_box;
	if(currentlySelectedSkin.female_icon != null):
		icon.texture = currentlySelectedSkin.female_icon;
	
	if(icon.texture == currentlySelectedSkin.female_icon && box.texture == currentlySelectedSkin.female_box):
		return;
	
	# NON-BINARY STUFF
	if(currentlySelectedSkin.nonbinary_box != null):
		box.texture = currentlySelectedSkin.nonbinary_box;
	
	if(currentlySelectedSkin.nonbinary_icon != null):
		icon.texture = currentlySelectedSkin.nonbinary_icon;



func OnMaleTypePressed():
	icon.texture = currentlySelectedSkin.male_icon;
	box.texture = currentlySelectedSkin.male_box;
	

func OnFemaleTypePressed():
	icon.texture = currentlySelectedSkin.female_icon;
	box.texture = currentlySelectedSkin.female_box;

func OnNonBinaryTypePressed():
	icon.texture = currentlySelectedSkin.nonbinary_icon;
	box.texture = currentlySelectedSkin.nonbinary_box;

