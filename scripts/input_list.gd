class_name InputList extends VBoxContainer

@onready var input_remap_module = preload("res://scenes/input_remap_module.tscn")

@export var input_list : Array[String]

var input_remap_list : Array[InputRemapModule]
var controller : String


func _ready() -> void:
	set_controller()
	generate_input_remap_list()


func set_controller() -> void:
	var first_controller = Input.get_connected_joypads()[0]
	controller = Input.get_joy_guid(first_controller)
	


func generate_input_remap_list() -> void:
	for input in input_list:
		if InputMap.has_action(input):
			initialize_input_remap_module(input)


func initialize_input_remap_module(input) -> void:
	var new_input_remap : InputRemapModule = input_remap_module.instantiate()
	input_remap_list.append(new_input_remap)
	add_child(new_input_remap)
	new_input_remap.set_input_display(input)
	if not new_input_remap.remapper_active.is_connected(_on_remapper_active):
		new_input_remap.remapper_active.connect(_on_remapper_active)


func _on_remapper_active(active_node: InputRemapModule) -> void:
	for remapper in input_remap_list:
		if not remapper == active_node:
			remapper.active = false
