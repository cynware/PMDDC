extends Resource
class_name PokemonData

var id: String
var name: String
var complete: int
var forms: Dictionary = {}

# Parse JSON into CreatureData objects
static func from_json(json_data: Dictionary) -> Dictionary:
	var result := {}
	for id in json_data.keys():
		var pokemon_dict = json_data[id]
		var pokemon = PokemonData.new()
		pokemon.id = pokemon_dict.get("id", "")
		pokemon.name = pokemon_dict.get("name", "")
		pokemon.complete = pokemon_dict.get("complete", 0)

		# Parse forms
		var form_dict := {}
		if "forms" in pokemon_dict:
			for form_id in pokemon_dict["forms"].keys():
				form_dict[form_id] = FormData.from_json(pokemon_dict["forms"][form_id])
		pokemon.forms = form_dict

		result[id] = pokemon
	return result
