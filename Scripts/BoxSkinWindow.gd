extends Control

@export var skinDropdown:OptionButton;
var loadedSkins:Array[PmdSkinData]
var internalSkinCount:int;
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
	"../../../../../NoticeScreen/InfoBorder",
	"../../../../../NoticeScreen/InfoBorder/InfoPortraitBorder",
	"../../../../DialogueTAB_BTN",
	"../../../../ThemesTAB_BTN",
	"../../../../PortraitTAB_BTN",
	"../../../../PresetsTAB_BTN",
	"../../../../TAB_DISPLAYNAME",
	"../../../../../DownloadScreen/InfoBorder/InfoPortraitBorder",
	"../../../../../DownloadScreen/InfoBorder"
]
var TextBoxChangeTargets = [
	"../../../../../PMD_Main/OptionBox/OptionBoxBorder"
]

func _ready():
	CheckAndCreateBoxSkinFolder();
	RefreshDropdown()
	OnSkinDropdownItemSelected(0);
	OnMaleTypePressed();
	#$"../../..".texture = currentlySelectedSkin.male_icon;

	
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
	internalSkinCount = InternalThemeDirectories.size()
	print("INTERNAL SKIN COUNT: " + str(internalSkinCount));
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
	SoundEffectManager.PlayChooseDropdown()
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
		UpdateDebugTabCorners(currentlySelectedSkin.male_icon, template_iconM);
	
	if(icon.texture == currentlySelectedSkin.male_icon && box.texture == currentlySelectedSkin.male_box):
		return;
	
	# FEMALE STUFF
	if(currentlySelectedSkin.female_box != null):
		box.texture = currentlySelectedSkin.female_box;
	if(currentlySelectedSkin.female_icon != null):
		icon.texture = currentlySelectedSkin.female_icon;
		UpdateDebugTabCorners(currentlySelectedSkin.female_icon, template_iconF);
	
	if(icon.texture == currentlySelectedSkin.female_icon && box.texture == currentlySelectedSkin.female_box):
		return;
	
	# NON-BINARY STUFF
	if(currentlySelectedSkin.nonbinary_box != null):
		box.texture = currentlySelectedSkin.nonbinary_box;
	
	if(currentlySelectedSkin.nonbinary_icon != null):
		icon.texture = currentlySelectedSkin.nonbinary_icon;
		UpdateDebugTabCorners(currentlySelectedSkin.nonbinary_icon, template_iconNB);

func OnMaleTypePressed():
	SoundEffectManager.PlayCheckboxOff()
	SelectGender(currentlySelectedSkin.male_icon, currentlySelectedSkin.male_box, template_iconM, 1);

func OnFemaleTypePressed():
	SoundEffectManager.PlayCheckboxOff()	
	SelectGender(currentlySelectedSkin.female_icon, currentlySelectedSkin.female_box, template_iconF, 2);

func OnNonBinaryTypePressed():
	SoundEffectManager.PlayCheckboxOff()	
	SelectGender(currentlySelectedSkin.nonbinary_icon, currentlySelectedSkin.nonbinary_box, template_iconNB, 3);
	
func SelectGender(newIcon:Texture2D, newBox:Texture2D, defaultSkin:Texture2D, genderId:int):
	currentlySelectedGender = genderId;
	
	icon.texture = newIcon;
	box.texture = newBox;
	
	UpdateDebugTabCorners(newIcon, defaultSkin)

func UpdateDebugTabCorners(newIcon:Texture2D, defaultSkin:Texture2D):
	for path in BoxChangeTargets:
		var node = get_node_or_null(path)
		if node:
			if currentlySelectedSkin in loadedSkins.slice(0,internalSkinCount):
				node.texture = newIcon
				UpdateThemePopup(newIcon, defaultSkin)
			else:
				node.texture = defaultSkin;
				UpdateThemePopup(newIcon, defaultSkin)
	for path in TextBoxChangeTargets:
		var node = get_node_or_null(path)
		if node:
			node.texture = box.texture

func UpdateThemePopup(newIcon:Texture2D, defaultSkin:Texture2D):
	var popupmenu = load("res://Assets/Themes/PMDButton.tres::StyleBoxTexture_0nymc")
	if currentlySelectedSkin in loadedSkins.slice(0,internalSkinCount):
		var img = newIcon.get_image()
		img.resize(img.get_width() * 3, img.get_height() * 3, Image.INTERPOLATE_NEAREST)
		popupmenu.texture = ImageTexture.create_from_image(img)
	else:
		var img = defaultSkin.get_image()
		img.resize(img.get_width() * 3, img.get_height() * 3, Image.INTERPOLATE_NEAREST)
		popupmenu.texture = ImageTexture.create_from_image(img)

func openCustomIconFolder():
	OS.shell_open(ProjectSettings.globalize_path("user://BoxSkins"))
	SoundEffectManager.PlayFolder()

func OnRefresh():
	RefreshDropdown()
	OnSkinDropdownItemSelected(0)
	SoundEffectManager.PlayRefresh()

func _input(event):
	if(Input.is_action_just_pressed("BACK") and visible):
		visible = false;
		SoundEffectManager.PlayCancel()
