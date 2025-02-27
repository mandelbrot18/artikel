extends Node

#will load a json file from path. returns dictionary. 
#example usage: var my_dialogue = Library.load_json_file("res://path/to/dialogue.json")
func load_json_file(filePath : String):
	if !FileAccess.file_exists(filePath):
		print("file doesn't exist")
		
	var dataFile = FileAccess.open(filePath, FileAccess.READ)
	var parsedResult = JSON.parse_string(dataFile.get_as_text())
	
	if parsedResult is not Dictionary:
		print("error with parsing")
	return parsedResult
