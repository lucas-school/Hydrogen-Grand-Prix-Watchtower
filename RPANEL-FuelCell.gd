extends Control

@onready var serial_data = $serialData

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	# hydrogen percent text
	$MarginContainer/VBoxContainer/CarStatus/HBoxContainer/VBoxContainer/H2RemainingBox/H2RemainingAmount.text = str(serial_data.hydrogen_remaining_percent) + "%"
	$MarginContainer/VBoxContainer/CarStatus/HBoxContainer/VBoxContainer/H2RemainingBox/H2RemainingAmount.add_theme_color_override("font_color",Color("1bc2b6")) #blue

	# current solenoid time text
	$MarginContainer/VBoxContainer/CarStatus/HBoxContainer/VBoxContainer/SolenoidTime/SolenoidTimeSec.text = str(serial_data.solenoid_time_calc) + "sec"

	# solenoid all time text
	$MarginContainer/VBoxContainer/CarStatus/HBoxContainer/VBoxContainer/SolenoidTotal/SolenoidTimeSec.text = str(serial_data.solenoid_time) + "sec"


func _on_ResetHydrogen_pressed():
	for node in get_tree().get_nodes_in_group("serial_data"):
		node.solenoid_time_difference += serial_data.solenoid_time_calc
