extends Control

@export var skinDropdown:OptionButton;
var loadedSkins:Array[PmdSkinData]
var currentlySelectedSkin:PmdSkinData;
var currentlySelectedGender:int;

@export var icon:Sprite2D;
@export var box:Sprite2D;

@export var maleTypeBTN:TextureButton;
@export var femaleTypeBTN:TextureButton;
@export var nonBinaryTypeBTN:TextureButton;


@export_category("TEMPLATE STUFF")
@export var template_boxM:Texture2D;
@export var template_iconM:Texture2D;
@export var template_boxF:Texture2D;
@export var template_iconF:Texture2D;
@export var template_boxNB:Texture2D;
@export var template_iconNB:Texture2D;

var BoxChangeTargets = [
	"../../..",
	"../../../../DialogueBTN/Border",
	"../../../../ThemesBTN/Border",
	"../../../../PresetsBTN/Border",
	"../../../../../Settings/SettingsMenu/SettingsPanel",
	"../../../../../ErrorScreen/ErrorBorder",
	"../../../../../ErrorScreen/ErrorBorder/ErrorPortraitBorder"
]

func _ready():
	CheckAndCreateBoxSkinFolder();
	RefreshDropdown()
	OnSkinDropdownItemSelected(0);
	OnMaleTypePressed();
	$"../../..".texture = currentlySelectedSkin.male_icon;

	
func CheckAndCreateBoxSkinFolder():
	if (!DirAccess.dir_exists_absolute("user://BoxSkins")):
		DirAccess.make_dir_absolute("user://BoxSkins")
		DirAccess.make_dir_absolute("user://BoxSkins/Template")
		
		DirAccess.make_dir_absolute("user://BoxSkins/Template/Male")
		template_boxM.get_image().save_png(ProjectSettings.globalize_path("user://BoxSkins/Template/Male/box.png"));
		template_iconM.get_image().save_png(ProjectSettings.globalize_path("user://BoxSkins/Template/Male/icon.png"));
		
		DirAccess.make_dir_absolute("user://BoxSkins/Template/Female")
		template_boxF.get_image().save_png(ProjectSettings.globalize_path("user://BoxSkins/Template/Female/box.png"));
		template_iconF.get_image().save_png(ProjectSettings.globalize_path("user://BoxSkins/Template/Female/icon.png"));
		
		DirAccess.make_dir_absolute("user://BoxSkins/Template/NonBinary")
		template_boxNB.get_image().save_png(ProjectSettings.globalize_path("user://BoxSkins/Template/NonBinary/box.png"));
		template_iconNB.get_image().save_png(ProjectSettings.globalize_path("user://BoxSkins/Template/NonBinary/icon.png"));
		
	else:
		print("BOX SKIN FOLDER ALREADY EXISTS")
		
# jus the skins that come bundled with PMDDC :>
func AddInternalSkins():
	skinDropdown.clear()
	loadedSkins.clear()
	var InternalThemeDirectories = DirAccess.get_directories_at("res://PmdSkins")
	print("...........INTERNAL SKINS............")
	print(InternalThemeDirectories)
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
		
		loadedSkins.push_back(skinData);
		skinDropdown.add_item(skin);

func AddCustomSkins():
	for dir in DirAccess.get_directories_at("user://BoxSkins/"):
		var path = "user://BoxSkins/" + dir;
		
		var skinData:PmdSkinData = PmdSkinData.new()
		if(DirAccess.dir_exists_absolute(path + "/Male")):
			skinData.male_icon = CreateImageFromLocal(path + "/Male/icon.png");
			skinData.male_box = CreateImageFromLocal(path + "/Male/box.png");
				
		if(DirAccess.dir_exists_absolute(path + "/Female")):
			skinData.female_icon = CreateImageFromLocal(path + "/Female/icon.png");
			skinData.female_box = CreateImageFromLocal(path + "/Female/box.png");
				
		if(DirAccess.dir_exists_absolute(path + "/NonBinary")):	
			skinData.nonbinary_icon = CreateImageFromLocal(path + "/NonBinary/icon.png");
			skinData.nonbinary_box = CreateImageFromLocal(path + "/NonBinary/box.png");
		
		loadedSkins.push_back(skinData);
		skinDropdown.add_item(dir);
		

func CreateImageFromLocal(imagepath:String):
	if(!FileAccess.file_exists(imagepath)):
		return null;
		
	var image = Image.load_from_file(imagepath)
	
	if image.load(imagepath) == OK:	
		var texture = ImageTexture.create_from_image(image);
		return texture;
		
func RefreshDropdown():
	AddInternalSkins()
	AddCustomSkins()
	print(loadedSkins)
	
func OnSkinDropdownItemSelected(index):
	currentlySelectedSkin = loadedSkins[index];
	maleTypeBTN.MarkAsAvailable()
	femaleTypeBTN.MarkAsAvailable()
	nonBinaryTypeBTN.MarkAsAvailable()
	
	# DISABLING IN CASE FILES DONT EXIST
	if(currentlySelectedSkin.male_box == null || currentlySelectedSkin.male_icon == null):
		maleTypeBTN.MarkAsUnavailable();
		
	if(currentlySelectedSkin.female_box == null || currentlySelectedSkin.female_icon == null):
		femaleTypeBTN.MarkAsUnavailable();
		
	if(currentlySelectedSkin.nonbinary_box == null || currentlySelectedSkin.nonbinary_icon == null):
		nonBinaryTypeBTN.MarkAsUnavailable();
		
	# MALE STUFF
	if(currentlySelectedSkin.male_box != null):
		box.texture = currentlySelectedSkin.male_box;
	if(currentlySelectedSkin.male_icon != null):
		icon.texture = currentlySelectedSkin.male_icon;
		for path in BoxChangeTargets:
			var node = get_node_or_null(path)
			if node:
				if currentlySelectedSkin in loadedSkins.slice(0,5):
					node.texture = currentlySelectedSkin.male_icon
				else:
					node.texture = load("res://PmdSkins/ExplorersOfSky/Male/icon.png")
	
	if(icon.texture == currentlySelectedSkin.male_icon && box.texture == currentlySelectedSkin.male_box):
		return;
	
	# FEMALE STUFF
	if(currentlySelectedSkin.female_box != null):
		box.texture = currentlySelectedSkin.female_box;
	if(currentlySelectedSkin.female_icon != null):
		icon.texture = currentlySelectedSkin.female_icon;
		for path in BoxChangeTargets:
			var node = get_node_or_null(path)
			if node:
				if currentlySelectedSkin in loadedSkins.slice(0,5):
					node.texture = currentlySelectedSkin.female_icon
				else:
					node.texture = load("res://PmdSkins/ExplorersOfSky/Female/icon.png")
	
	if(icon.texture == currentlySelectedSkin.female_icon && box.texture == currentlySelectedSkin.female_box):
		return;
	
	# NON-BINARY STUFF
	if(currentlySelectedSkin.nonbinary_box != null):
		box.texture = currentlySelectedSkin.nonbinary_box;
	
	if(currentlySelectedSkin.nonbinary_icon != null):
		icon.texture = currentlySelectedSkin.nonbinary_icon;
		for path in BoxChangeTargets:
			var node = get_node_or_null(path)
			if node:
				if currentlySelectedSkin in loadedSkins.slice(0,5):
					node.texture = currentlySelectedSkin.nonbinary_icon
				else:
					node.texture = load("res://PmdSkins/ExplorersOfSky/Nonbinary/icon.png")



func OnMaleTypePressed():
	SelectGender(currentlySelectedSkin.male_icon, currentlySelectedSkin.male_box, load("res://PmdSkins/ExplorersOfSky/Male/icon.png"), 1);

func OnFemaleTypePressed():
	SelectGender(currentlySelectedSkin.female_icon, currentlySelectedSkin.female_box, load("res://PmdSkins/ExplorersOfSky/Female/icon.png"), 2);

func OnNonBinaryTypePressed():
	SelectGender(currentlySelectedSkin.nonbinary_icon, currentlySelectedSkin.nonbinary_box, load("res://PmdSkins/ExplorersOfSky/Nonbinary/icon.png"), 3);
	
func SelectGender(newIcon:Texture2D, newBox:Texture2D, defaultSkin:Texture2D, genderId:int):
	currentlySelectedGender = genderId;
	
	icon.texture = newIcon;
	box.texture = newBox;
	
	for path in BoxChangeTargets:
		var node = get_node_or_null(path)
		if node:
			if currentlySelectedSkin in loadedSkins.slice(0,5):
				node.texture = newIcon
			else:
				node.texture = defaultSkin;
				
func openCustomIconFolder():
	OS.shell_open(ProjectSettings.globalize_path("user://BoxSkins"))
	var sound_player = $FolderBTN/FolderBTNSound
	sound_player.pitch_scale = randf_range(0.95, 1.05)
	sound_player.play()

func OnRefresh():
	RefreshDropdown()
	OnSkinDropdownItemSelected(0)
	var sound_player = $RefreshBTN/RefreshBTNSound
	sound_player.pitch_scale = randf_range(0.95, 1.05)
	sound_player.play()
	
