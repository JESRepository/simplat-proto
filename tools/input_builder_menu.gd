@tool
class_name InputBuilderMenu
extends Control

signal save_input_map
signal discard_input_map

@onready var inputs_v_box: VBoxContainer = $VBoxContainer/InputsVBox

@onready var add_input_button: Button = $VBoxContainer/AddInputButton

var inputs : Array[HBoxContainer]
var events : Array[InputEvent]
var active_bind : Button

func _ready() -> void:
	if not add_input_button.pressed.is_connected(_on_add_input_pressed):
		add_input_button.pressed.connect(_on_add_input_pressed)


func _unhandled_input(event: InputEvent) -> void:
	if active_bind != null:
		events.set(inputs.find(active_bind.get_parent()), event)
		active_bind.text = event.as_text()
		active_bind = null
		save()


func _on_add_input_pressed() -> HBoxContainer:
	var input_hbox := HBoxContainer.new()
	
	inputs.append(input_hbox)
	events.append(null)
	
	var text_field := TextEdit.new()
	var bind_button := Button.new()
	var remove_input_button := Button.new()
	text_field.custom_minimum_size = Vector2(150, 25)
	remove_input_button.text = "-"
	bind_button.text = "Bind"
	
	input_hbox.add_child(text_field)
	input_hbox.add_child(bind_button)
	input_hbox.add_child(remove_input_button)
	inputs_v_box.add_child(input_hbox)
	
	if not text_field.text_changed.is_connected(_on_input_name_changed):
		text_field.text_changed.connect(_on_input_name_changed.bind(text_field))
	if not bind_button.pressed.is_connected(_on_bind_button_pressed):
		bind_button.pressed.connect(_on_bind_button_pressed.bind(bind_button))
	if not remove_input_button.pressed.is_connected(_on_remove_input_pressed):
		remove_input_button.pressed.connect(_on_remove_input_pressed.bind(remove_input_button))
	
	return input_hbox


func _on_input_name_changed(calling_object: TextEdit) -> void:
	save()


func _on_bind_button_pressed(calling_object: Object) -> void:
	calling_object.text = "..."
	active_bind = calling_object


func _on_remove_input_pressed(calling_object: Button) -> void:
	var hbox : HBoxContainer = calling_object.get_parent()
	if hbox in inputs:
		var index = inputs.find(hbox) 
		inputs.erase(hbox)
		events.remove_at(index)
		
		var dir = check_input_dir()
		
		var input = hbox.get_child(0).text
		hbox.queue_free()
		
		if input == "":
			return
		if ResourceLoader.exists(Saveload.INPUT_EVENT_LOCATION + input + ".res"):
			dir.remove(Saveload.INPUT_EVENT_LOCATION + input + ".res")
	save()


func set_custom_inputs(custom_inputs: Dictionary[String, InputEvent]) -> void:
	var keys = custom_inputs.keys()
	for input in keys:
		var new_hbox = _on_add_input_pressed()
		var text_box : TextEdit = new_hbox.get_child(0)
		text_box.text = input
		events.set(inputs.find(new_hbox), custom_inputs[input])
		var button : Button = new_hbox.get_child(1)
		button.text = custom_inputs[input].as_text()


func save() -> void:
	var custom_inputs : Dictionary[String, InputEvent]
	for hbox in inputs:
		var input = hbox.get_child(0).text
		if input == "":
			print("ERROR: cannot save an unnamed input")
			return
		custom_inputs.set(input, events.get(inputs.find(hbox)))
	save_input_map.emit(custom_inputs)
	
	var dir = check_input_dir()
	var files = dir.get_files()
	
	var input_names : Array[String]
	
	for hbox in inputs:
		var input = hbox.get_child(0).text
		if input != "":
			input_names.append(input + ".res")
	
	for file in files:
		if not input_names.has(file):
			dir.remove(Saveload.INPUT_EVENT_LOCATION + file)


func check_input_dir() -> DirAccess:
	var dir = DirAccess.open("user://")
	if dir.change_dir(Saveload.INPUT_EVENT_FOLDER) != Error.OK:
		dir.make_dir(Saveload.INPUT_EVENT_LOCATION)
	return dir
