@tool
class_name InputBuilder
extends EditorScript

var window: Window
var gui := preload("uid://bwckhy73domr2")
var gui_scene : InputBuilderMenu

var custom_inputs : Dictionary[String, InputEvent]

func _run():
	window = Window.new()
	EditorInterface.popup_dialog(window, Rect2(Vector2(1000, 1000), Vector2(960, 480)))
	
	gui_scene = gui.instantiate()
	window.add_child(gui_scene)
	connect_gui(gui_scene)
	window.close_requested.connect(func():
		window.queue_free()
	)
	
	load_map()


func save_map(new_inputs: Dictionary[String, InputEvent]) -> void:
	var file = FileAccess.open(Saveload.REBIND_LOCATION, FileAccess.WRITE)
	#file.store_var(custom_inputs.duplicate_deep())
	var keys = new_inputs.keys()
	
	var dir = DirAccess.open("user://")
	if dir.change_dir(Saveload.INPUT_EVENT_FOLDER) != Error.OK:
		dir.make_dir(Saveload.INPUT_EVENT_LOCATION)
	
	for key in keys:
		var curr_resource : Resource = new_inputs[key]
		if curr_resource != null:
			ResourceSaver.save(new_inputs[key], (Saveload.INPUT_EVENT_LOCATION + key + ".res"))
	file.store_var(keys)
	file.close()
	if FileAccess.file_exists(Saveload.REBIND_LOCATION):
		print("save success to " + str(ProjectSettings.globalize_path(Saveload.REBIND_LOCATION)))


func load_map() -> void:
	if FileAccess.file_exists(Saveload.REBIND_LOCATION):
		var file = FileAccess.open(Saveload.REBIND_LOCATION, FileAccess.READ)
		var data = file.get_var()
		file.close()
		print(data)
		
		if not data is Array[String]:
			return
		for input in data:
			var event = ResourceLoader.load(Saveload.INPUT_EVENT_LOCATION + input + ".res")
			custom_inputs.set(input, event)
		gui_scene.set_custom_inputs(custom_inputs)


func connect_gui(new_gui: InputBuilderMenu) -> void:
	new_gui.save_input_map.connect(save_map)
