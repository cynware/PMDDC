extends Node
# File: creature_data.gd
extends Resource
class_name CreatureData

@export var id: String
@export var name: String
@export var complete: int
@export var forms: Dictionary = {}

# Parse JSON into CreatureData objects
static func from_json(json_data: Dictionary) -> Dictionary:
	var result := {}
	for id in json_data.keys():
		var creature_dict = json_data[id]
		var creature = CreatureData.new()
		creature.id = creature_dict.get("id", "")
		creature.name = creature_dict.get("name", "")
		creature.complete = creature_dict.get("complete", 0)

		# Parse forms
		var form_dict := {}
		if "forms" in creature_dict:
			for form_id in creature_dict["forms"].keys():
				form_dict[form_id] = FormData.from_json(creature_dict["forms"][form_id])
		creature.forms = form_dict

		result[id] = creature
	return result


# File: form_data.gd
extends Resource
class_name FormData

@export var name: String
@export var bot_path: String
@export var complete: int
@export var filename: String
@export var portraits: Array = []
@export var preversed: Variant
@export var credits: Array = []
@export var modified: String

static func from_json(form_json: Dictionary) -> FormData:
	var f = FormData.new()
	f.name = form_json.get("name", "")
	f.bot_path = form_json.get("botPath", "")
	f.complete = form_json.get("complete", 0)
	f.filename = form_json.get("filename", "")
	f.portraits = form_json.get("portraits", [])
	f.preversed = form_json.get("preversed", [])
	f.credits = form_json.get("credits", [])
	f.modified = form_json.get("modified", "")
	return f
