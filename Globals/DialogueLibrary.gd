extends Node


func _ready() -> void:
	var test_script = load_json_file("res://scripts/test_script.json")
	#print(extract_lines(test_script, "german"))
	
	
#will load a json file from path. returns dictionary. 
#example: var my_dialogue = Library.load_json_file("res://path/to/dialogue.json")
func load_json_file(filePath : String) -> Dictionary:
	assert(FileAccess.file_exists(filePath))
	var dataFile = FileAccess.open(filePath, FileAccess.READ)
	var parsedResult = JSON.parse_string(dataFile.get_as_text())
	
	if parsedResult is not Dictionary:
		print("error with parsing")
	return parsedResult

#takes a parsed json file (with load_json_file)
#will extract only the dialogue in one language 
#returns an array containing only strings
#example: extract_lines({"german" : [{"name":"Ich", "line": "Hallo. Ich suche Birnen."}]})
# --> ["Hallo. Ich suche Birnen."]
func extract_lines(script, language) -> Array:
	var extracted_lines = []
	assert(script.has(language))
	for dict in script[language]:
		extracted_lines.append(dict["line"])
	return extracted_lines
