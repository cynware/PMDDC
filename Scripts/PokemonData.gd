# PokemonData.gd
extends Resource
class_name PokemonData

var id: String = ""
var name: String = ""
var complete: int = 0
var forms: Dictionary = {} 

static func from_json_entry(entry: Dictionary) -> PokemonData:
	var p := PokemonData.new()
	p.id = str(entry.get("id", ""))
	p.name = entry.get("name", "")
	p.complete = int(entry.get("complete", 0))

	var form_dict: Dictionary = {}
	var forms_src = entry.get("forms", {})
	if typeof(forms_src) == TYPE_DICTIONARY:
		for form_id in forms_src.keys():
			var form_data = forms_src[form_id]
			if typeof(form_data) == TYPE_DICTIONARY:
				form_dict[form_id] = FormData.from_json(form_data)
	p.forms = form_dict
	return p


static func from_json_root(json_root: Dictionary) -> Dictionary:
	var result: Dictionary = {}
	for id_key in json_root.keys():
		var poke_dict = json_root[id_key]
		if typeof(poke_dict) == TYPE_DICTIONARY:
			result[id_key] = PokemonData.from_json_entry(poke_dict)
	return result
