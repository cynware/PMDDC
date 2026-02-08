extends Resource
class_name PokemonData

var id: String = ""
var name: String = ""
var forms: Dictionary = {} 

static func from_json_entry(entry: Dictionary, id_str: String = "") -> PokemonData:
	var p := PokemonData.new()
	p.id = id_str
	p.name = entry.get("name", "Unknown")

	var root_portraits = entry.get("portrait_files", {})
	if typeof(root_portraits) == TYPE_DICTIONARY and not root_portraits.is_empty():
		var f = FormData.from_json(entry)
		f.name = "Normal" 
		f.relative_path = ""
		p.forms["Normal"] = f

	var subgroups = entry.get("subgroups", {})
	if typeof(subgroups) == TYPE_DICTIONARY:
		p._parse_subgroups(subgroups, "", "", p.forms)
		
	return p

func _parse_subgroups(subgroups: Dictionary, parent_name: String, parent_path: String, result_forms: Dictionary):
	for key in subgroups.keys():
		var data = subgroups[key]
		if typeof(data) != TYPE_DICTIONARY: continue
		
		var raw_name = data.get("name", "")
		var current_name = raw_name
		var current_path = parent_path
		
		if raw_name != "":
			if parent_path != "":
				current_path = parent_path.path_join(raw_name)
			else:
				current_path = raw_name
		
		if parent_name != "":
			if raw_name != "":
				current_name = parent_name + " " + raw_name
			else:
				current_name = parent_name
		else:
			if raw_name == "":
				current_name = "Normal" 
				
		var p_files = data.get("portrait_files", {})
		if typeof(p_files) == TYPE_DICTIONARY and not p_files.is_empty():
			var f = FormData.from_json(data)
			f.name = current_name
			f.relative_path = current_path
			
			result_forms[current_name] = f
			
		var nested = data.get("subgroups", {})
		if typeof(nested) == TYPE_DICTIONARY:
			_parse_subgroups(nested, current_name, current_path, result_forms)

static func from_json_root(json_root: Dictionary) -> Dictionary:
	var result: Dictionary = {}
	for id_key in json_root.keys():
		var poke_dict = json_root[id_key]
		if typeof(poke_dict) == TYPE_DICTIONARY:
			result[id_key] = PokemonData.from_json_entry(poke_dict, id_key)
	return result
