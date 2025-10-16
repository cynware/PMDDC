extends Resource
class_name FormData

var name: String
var bot_path: String
var complete: int
var filename: String
var portraits: Array = []
var preversed
var credits: Array = []
var modified: String

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
