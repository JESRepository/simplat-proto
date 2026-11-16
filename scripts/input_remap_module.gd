class_name InputRemapModule extends HBoxContainer

signal remapper_active

var active: bool = false
var input_name: String

const CONTROLLER_BUTTON_LABELS = {
	JoyButton.JOY_BUTTON_A: "Action Button Down",
	JoyButton.JOY_BUTTON_B: "Action Button Right",
	JoyButton.JOY_BUTTON_X: "Action Button Up",
	JoyButton.JOY_BUTTON_Y: "Action Button Left",
	JoyButton.JOY_BUTTON_DPAD_UP : "DPad Up",
	JoyButton.JOY_BUTTON_DPAD_LEFT : "DPad Left",
	JoyButton.JOY_BUTTON_DPAD_DOWN : "DPad Down",
	JoyButton.JOY_BUTTON_LEFT_SHOULDER : "LB",
	JoyButton.JOY_BUTTON_RIGHT_SHOULDER : "RB",
	JoyButton.JOY_BUTTON_LEFT_STICK : "L3",
	JoyButton.JOY_BUTTON_RIGHT_STICK : "R3",
	JoyButton.JOY_BUTTON_START : "Start",
	JoyButton.JOY_BUTTON_BACK : "Select",
}

const CONTROLLER_AXIS_LABELS = {
	JoyAxis.JOY_AXIS_TRIGGER_LEFT : "LT",
	JoyAxis.JOY_AXIS_TRIGGER_RIGHT : "RT",
	JoyAxis.JOY_AXIS_LEFT_X : "Left Stick",
	JoyAxis.JOY_AXIS_LEFT_Y : "Left Stick",
	JoyAxis.JOY_AXIS_RIGHT_X: "Right Stick",
	JoyAxis.JOY_AXIS_RIGHT_Y: "Right Stick", 
}

@onready var input_label : Label = $Label
@onready var rebind_button : Button = $Button

func _ready() -> void:
	if not rebind_button.pressed.is_connected(_on_rebind_pressed):
		rebind_button.pressed.connect(_on_rebind_pressed)


func _unhandled_input(event: InputEvent) -> void:
	if not active:
		return
	set_input(event)
	set_input_display(input_name)
	active = false


func set_input(event: InputEvent) -> void:
	InputMap.action_erase_events(input_name)
	InputMap.action_add_event(input_name, event)


func set_input_display(new_input_name: String) -> void:
	if not InputMap.has_action(new_input_name):
		return
	input_name = new_input_name
	input_label.text = input_name
	var input_button = InputMap.action_get_events(input_name)[0]
	rebind_button.text = get_input_name(input_button)


func get_input_name(input: InputEvent) -> String:
	var new_name = ""
	if input is InputEventJoypadButton:
		if CONTROLLER_BUTTON_LABELS.has(input.button_index):
			new_name = CONTROLLER_BUTTON_LABELS.get(input.button_index)
	elif input is InputEventJoypadMotion:
		if CONTROLLER_AXIS_LABELS.has(input.axis):
			new_name = CONTROLLER_AXIS_LABELS.get(input.axis)
	else:
		new_name = input.as_text()
	if new_name == "":
		new_name = input.as_text()
	return new_name


func _on_rebind_pressed() -> void:
	remapper_active.emit(self)
	active = true
	rebind_button.text = "..."
