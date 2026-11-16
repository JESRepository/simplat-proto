class_name InputRemapModule extends HBoxContainer

const CONTROLLER_BUTTON_LABELS = {
	JoyButton.JOY_BUTTON_A: "Action Button Down",
	JoyButton.JOY_BUTTON_B: "Action Button Right",
	JoyButton.JOY_BUTTON_X: "Action Button Up",
	JoyButton.JOY_BUTTON_Y: "Action Button Left",
	JoyButton.JOY_BUTTON_DPAD_UP : "DPad Up",
	JoyButton.JOY_BUTTON_DPAD_LEFT : "DPad Left",
	JoyButton.JOY_BUTTON_DPAD_DOWN : "Dpad Down",
	JoyButton.JOY_BUTTON_LEFT_SHOULDER : "LB",
	JoyButton.JOY_BUTTON_RIGHT_SHOULDER : "RB",
	JoyButton.JOY_BUTTON_LEFT_STICK : "L3",
	JoyButton.JOY_BUTTON_RIGHT_STICK : "R3",
	JoyButton.JOY_BUTTON_START : "Start",
	JoyButton.JOY_BUTTON_GUIDE : "Select",
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
@onready var input_rebind_button : Button = $Button


func set_input(input_name: String) -> void:
	input_label.text = input_name
	var input_button = InputMap.action_get_events(input_name)[0]
	input_rebind_button.text = get_input_name(input_button)


func get_input_name(input: InputEvent) -> String:
	var new_name = ""
	print(input)
	if input is InputEventJoypadButton:
		if CONTROLLER_BUTTON_LABELS.has(input.button_index):
			new_name = CONTROLLER_BUTTON_LABELS.get(input.button_index)
	if input is InputEventJoypadMotion:
		if CONTROLLER_AXIS_LABELS.has(input.axis):
			new_name = CONTROLLER_AXIS_LABELS.get(input.axis)
	
	return new_name
