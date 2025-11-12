# FormData.gd
extends Resource
class_name FormData

var name: String = ""
var bot_path: String = ""
var complete: int = 0
var filename: String = ""
var portraits: PackedInt32Array = PackedInt32Array()
var preversed: PackedInt32Array = PackedInt32Array()
var credits: Array = []
var modified: String = ""

static func from_json(form_json: Dictionary) -> FormData:
	var f := FormData.new()
	f.name = form_json.get("name", "")
	f.bot_path = form_json.get("botPath", "")
	f.complete = int(form_json.get("complete", 0))
	f.filename = form_json.get("filename", "")

	var portraits_data = form_json.get("portraits", [])
	if portraits_data is Array:
		f.portraits = PackedInt32Array(portraits_data)

	var preversed_data = form_json.get("preversed", [])
	if preversed_data is Array:
		f.preversed = PackedInt32Array(preversed_data)

	f.credits = form_json.get("credits", [])
	f.modified = form_json.get("modified", "")
	return f
