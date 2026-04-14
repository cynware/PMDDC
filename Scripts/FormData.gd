extends Resource
class_name FormData

var name: String = ""
var emotions: Array = []
var relative_path: String = ""

static func from_json(form_json: Dictionary) -> FormData:
	var f := FormData.new()
	f.name = form_json.get("name", "")
	
	var p_files = form_json.get("portrait_files", {})
	if typeof(p_files) == TYPE_DICTIONARY:
		for emotion in p_files.keys():
			f.emotions.append(emotion)
				
	return f
