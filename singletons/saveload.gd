@tool
extends Node

const SAVE_LOCATION = "user://SaveFile.json"
const REBIND_LOCATION = "user://custom_inputs.json"
const INPUT_EVENT_LOCATION = "user://"
const INPUT_EVENT_DIR = ""

var save_data: Dictionary = {
	
}

func _save():
	var file = FileAccess.open(SAVE_LOCATION, FileAccess.WRITE)
	file.store_var(save_data.duplicate())
	file.close()


func _load():
	if FileAccess.file_exists(SAVE_LOCATION):
		var file = FileAccess.open(SAVE_LOCATION, FileAccess.READ)
		var data = file.get_var()
		file.close()
		
		if save_data.has_all(data.get_keys()):
			save_data.merge(data, true)
