extends Control

@onready var serial_data = $serialData


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(_delta):
	if serial_data.battery_voltage > 1:
		$MarginContainer/VBoxContainer/CarStatus/BatteryVoltageBox/BatteryVoltageCurrent.text = str(serial_data.battery_voltage)
		$MarginContainer/VBoxContainer/CarStatus/BatteryVoltageBox/BatteryVoltageCurrent.add_theme_color_override("font_color",Color("1b1ec2")) #blue
	else:
		$MarginContainer/VBoxContainer/CarStatus/BatteryVoltageBox/BatteryVoltageCurrent.text = "Disconnected"
		$MarginContainer/VBoxContainer/CarStatus/BatteryVoltageBox/BatteryVoltageCurrent.add_theme_color_override("font_color",Color("c21b1b")) #red
		
