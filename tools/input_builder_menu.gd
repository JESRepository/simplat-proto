@tool
class_name InputBuilderMenu
extends Control

signal save_input_map
signal discard_input_map

@onready var inputs_v_box: VBoxContainer = $VBoxContainer/InputsVBox

@onready var add_input_button: Button = $VBoxContainer/AddInputButton
@onready var save_button: Button = $VBoxContainer/HBoxContainer/SaveButton
@onready var discard_button: Button = $VBoxContainer/HBoxContainer/DiscardButton

var inputs : Array[HBoxContainer]
var events : Array[InputEvent]
var active_bind : Button

func _ready() -> void:
	if not add_input_button.pressed.is_connected(_on_add_input_pressed):
		add_input_button.pressed.connect(_on_add_input_pressed)
	if not save_button.pressed.is_connected(_on_save_pressed):
		save_button.pressed.connect(_on_save_pressed)
	if not discard_button.pressed.is_connected(_on_discard_pressed):
		discard_button.pressed.connect(_on_discard_pressed)


func _unhandled_input(event: InputEvent) -> void:
	if active_bind != null:
		events.set(inputs.find(active_bind.get_parent()), event)
		active_bind.text = event.as_text()
		active_bind = null


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
	pass


func _on_bind_button_pressed(calling_object: Object) -> void:
	calling_object.text = "..."
	active_bind = calling_object


func _on_remove_input_pressed(calling_object: Button) -> void:
	var hbox : HBoxContainer = calling_object.get_parent()
	if hbox in inputs:
		var index = inputs.find(hbox) 
		inputs.erase(hbox)
		events.remove_at(index)
	hbox.queue_free()


func reload() -> void:
	for x in inputs:
		x.queue_free()
	inputs.clear()
	events.clear()
	active_bind = null


func set_custom_inputs(custom_inputs: Dictionary[String, InputEvent]) -> void:
	var keys = custom_inputs.keys()
	for input in keys:
		var new_hbox = _on_add_input_pressed()
		var text_box : TextEdit = new_hbox.get_child(0)
		text_box.text = input
		events.set(inputs.find(new_hbox), custom_inputs[input])
		var button : Button = new_hbox.get_child(1)
		button.text = custom_inputs[input].as_text()


func _on_save_pressed() -> void:
	var custom_inputs : Dictionary[String, InputEvent]
	for hbox in inputs:
		custom_inputs.set(hbox.get_child(0).text, events.get(inputs.find(hbox)))
	#print("custom inputs are: " + str(custom_inputs))
	save_input_map.emit(custom_inputs)


func _on_discard_pressed() -> void:
	reload()
