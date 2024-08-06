class_name PmdTheme extends Resource

enum ThemeTypes {
	MALE,
	FEMALE,
	NONBINARY
}

@export var themeName:String;
## not working currently
@export var defaultType:ThemeTypes;

@export_subgroup("Male Textures")
@export var icon_M:Texture;
@export var box_M:Texture;

@export_subgroup("Female Textures")
@export var icon_F:Texture;
@export var box_F:Texture;

@export_subgroup("Non-Binary Textures")
@export var icon_NB:Texture;
@export var box_NB:Texture;
