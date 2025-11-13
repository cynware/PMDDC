extends Control



signal http_text_ready(text: String, ok: bool)

# So in case the link changes we dont need to make a new version
var pmdCollabJsonMirror:String = "https://raw.githubusercontent.com/cynware/PMDDC-Data/refs/heads/main/pmdcollabmirror.txt";
var pmdCollabJsonLink:String;
var pmdCollabJson;

func _ready():
	pmdCollabJsonLink = await fetchHttpTextContent(pmdCollabJsonMirror);
	
	if(pmdCollabJsonLink == ""):
		print("Failed to grab pmdCollabJsonMirror");
	else:
		print("pmdCollabJsonMirror: " + pmdCollabJsonLink);
		HandlePmdCollabJson(pmdCollabJsonLink.strip_edges())

func HandlePmdCollabJson(URL:String):
		var pmdCollabJsonTxt = await fetchHttpTextContent(URL)
		
		if(pmdCollabJsonTxt == ""):
			print("Failed to grab pmdCollabJson content");
		else:
			pmdCollabJson = JSON.parse_string(pmdCollabJsonTxt)
			
			if typeof(pmdCollabJson) == TYPE_DICTIONARY:
				var pokedex := PokemonData.from_json_root(pmdCollabJson)
				print("Loaded Pokémon:", pokedex.size())
				var first_key = pokedex.keys()[0]
				var first_poke: PokemonData = pokedex[first_key]
				
				for i in range(100):
					var pkmn = pokedex["%04d" % i]
					prints(pkmn.id, pkmn.name, "forms:", pkmn.forms.size())
			else:
				push_error("Invalid JSON structure")
				
			
			
	
func fetchHttpTextContent(URL: String):
	var http_request := HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(self.OnHttpTextRequestCompleted)

	var err := http_request.request(URL)
	if err != OK:
		http_request.queue_free()
		return ""

	# Wait until OnHttpTextRequestCompleted emits our signal
	var result = await self.http_text_ready
	# result is an Array [text, ok]
	var text: String = result[0]
	var ok: bool = result[1]

	http_request.queue_free()
	
	if(ok):
		return text;
	else:
		return "";

func OnHttpTextRequestCompleted(result, response_code, headers, body):
	if result == HTTPRequest.RESULT_SUCCESS and response_code >= 200 and response_code < 300:
		var text = body.get_string_from_utf8()
		emit_signal("http_text_ready", text, true)
	else:
		print("Failed to grab text. Error code: ", result, " HTTP: ", response_code)
		emit_signal("http_text_ready", "", false)
