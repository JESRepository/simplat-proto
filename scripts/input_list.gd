class_name InputList extends VBoxContainer

@onready var input_remap_module = preload("res://scenes/input_remap_module.tscn")

var input_list : Array[String]

var input_remap_list : Array[InputRemapModule]
var controller : String


func _ready() -> void:
	set_controller()
	generate_input_remap_list()


func set_controller() -> void:
	var first_controller = Input.get_connected_joypads()[0]
	controller = Input.get_joy_guid(first_controller)
	


func generate_input_remap_list() -> void:
	var data : Array[String]
	if FileAccess.file_exists(Saveload.REBIND_LOCATION):
		var file = FileAccess.open(Saveload.REBIND_LOCATION, FileAccess.READ)
		data = file.get_var()
		file.close()
		if not data is Array[String]:
			return
		# creates a list of input names
		input_list = data
	
	for input in input_list:
		var event = ResourceLoader.load(Saveload.INPUT_EVENT_LOCATION + input + ".res")
		if not InputMap.has_action(input):
			InputMap.add_action(input)
		if not InputMap.action_has_event(input, event):
			InputMap.action_add_event(input, event)
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
