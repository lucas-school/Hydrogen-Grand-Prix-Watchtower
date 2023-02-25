extends Control

onready var serial_data = $serialData

func _ready():
	pass
	
func _process(delta):
	# car status and error codes
	if serial_data.red_led == 0 and serial_data.green_led == 0 and serial_data.battery_voltage > 6:
		$MarginContainer/VBoxContainer/CarStatus/OverallStatus/Status.text = "Battery Power"
		$MarginContainer/VBoxContainer/CarStatus/OverallStatus/Status.add_color_override("font_color",Color("36c21b")) #green
	elif serial_data.red_led == 0 and serial_data.green_led == 1 and serial_data.battery_voltage > 6:
		$MarginContainer/VBoxContainer/CarStatus/OverallStatus/Status.text = "Hydrogen Power"
		$MarginContainer/VBoxContainer/CarStatus/OverallStatus/Status.add_color_override("font_color",Color("36c21b")) #green
	else:
		$MarginContainer/VBoxContainer/CarStatus/OverallStatus/Status.text = "Error"
		$MarginContainer/VBoxContainer/CarStatus/OverallStatus/Status.add_color_override("font_color",Color("c21b1b")) #green
		
	# same order as manual
	if serial_data.red_led_flashing and serial_data.green_led == 0:
		$MarginContainer/VBoxContainer/CarStatus/ConnectionBox/ConnectionStatus.text = "Lithium battery voltage <6V"
		$MarginContainer/VBoxContainer/CarStatus/ConnectionBox/ConnectionStatus.add_color_override("font_color",Color("c21b1b")) #red
	elif serial_data.red_led == 1 and serial_data.green_led == 0:
		$MarginContainer/VBoxContainer/CarStatus/ConnectionBox/ConnectionStatus.text = "Fuel cell stack voltage <8.4V"
		$MarginContainer/VBoxContainer/CarStatus/ConnectionBox/ConnectionStatus.add_color_override("font_color",Color("c21b1b")) #red
	elif serial_data.red_led_flashing and serial_data.green_led == 1:
		$MarginContainer/VBoxContainer/CarStatus/ConnectionBox/ConnectionStatus.text = "Online, Lithium battery voltage <7V"
		$MarginContainer/VBoxContainer/CarStatus/ConnectionBox/ConnectionStatus.add_color_override("font_color",Color("b9c21b")) #yellow
	elif serial_data.red_led == 0 and serial_data.green_led == 1:
		$MarginContainer/VBoxContainer/CarStatus/ConnectionBox/ConnectionStatus.text = "Online"
		$MarginContainer/VBoxContainer/CarStatus/ConnectionBox/ConnectionStatus.add_color_override("font_color",Color("36c21b")) #green
	elif serial_data.red_led == 1 and serial_data.green_led == 0:
		$MarginContainer/VBoxContainer/CarStatus/ConnectionBox/ConnectionStatus.text = "Fuel cell stack voltage <6.7V"
		$MarginContainer/VBoxContainer/CarStatus/ConnectionBox/ConnectionStatus.add_color_override("font_color",Color("c21b1b")) #red
	elif serial_data.red_led_flashing and serial_data.green_led_flashing:
		$MarginContainer/VBoxContainer/CarStatus/ConnectionBox/ConnectionStatus.text = "Lithium battery voltage <6V"
		$MarginContainer/VBoxContainer/CarStatus/ConnectionBox/ConnectionStatus.add_color_override("font_color",Color("c21b1b")) #red
	elif serial_data.red_led == 1 and serial_data.green_led_flashing:
		$MarginContainer/VBoxContainer/CarStatus/ConnectionBox/ConnectionStatus.text = "Fuel cell stack temperature >65C"
		$MarginContainer/VBoxContainer/CarStatus/ConnectionBox/ConnectionStatus.add_color_override("font_color",Color("c21b1b")) #red
	elif serial_data.red_led == 0 and serial_data.green_led_flashing:
		$MarginContainer/VBoxContainer/CarStatus/ConnectionBox/ConnectionStatus.text = "Hydrogen pressure low"
		$MarginContainer/VBoxContainer/CarStatus/ConnectionBox/ConnectionStatus.add_color_override("font_color",Color("c21b1b")) #red
	elif serial_data.red_led == 0 and serial_data.green_led == 0:
		$MarginContainer/VBoxContainer/CarStatus/ConnectionBox/ConnectionStatus.text = "Hydrogen Offline"
		$MarginContainer/VBoxContainer/CarStatus/ConnectionBox/ConnectionStatus.add_color_override("font_color",Color("6d000000")) #red
	else:
		$MarginContainer/VBoxContainer/CarStatus/ConnectionBox/ConnectionStatus.text = "Unknown"
		$MarginContainer/VBoxContainer/CarStatus/ConnectionBox/ConnectionStatus.add_color_override("font_color",Color("c21b1b")) #red
		
	
	#LED status
	if serial_data.connected:
		# red led
		if serial_data.red_led == 0:
			$MarginContainer/VBoxContainer/CarStatus/RedLEDBox/RedLEDStatus.text = "Offline"
			$MarginContainer/VBoxContainer/CarStatus/RedLEDBox/RedLEDStatus.add_color_override("font_color",Color("6d000000")) #grey
		elif serial_data.red_led == 1:
			$MarginContainer/VBoxContainer/CarStatus/RedLEDBox/RedLEDStatus.text = "Showing"
			$MarginContainer/VBoxContainer/CarStatus/RedLEDBox/RedLEDStatus.add_color_override("font_color",Color("c21b1b")) #red
		else:
			$MarginContainer/VBoxContainer/CarStatus/RedLEDBox/RedLEDStatus.text = "Flashing"
			$MarginContainer/VBoxContainer/CarStatus/RedLEDBox/RedLEDStatus.add_color_override("font_color",Color("c21b1b")) #red
			
		# green led
		if serial_data.green_led == 0:
			$MarginContainer/VBoxContainer/CarStatus/GreenLEDBox/GreenLEDStatus.text = "Offline"
			$MarginContainer/VBoxContainer/CarStatus/GreenLEDBox/GreenLEDStatus.add_color_override("font_color",Color("c21b1b")) #red
		elif serial_data.green_led == 1:
			$MarginContainer/VBoxContainer/CarStatus/GreenLEDBox/GreenLEDStatus.text = "Showing"
			$MarginContainer/VBoxContainer/CarStatus/GreenLEDBox/GreenLEDStatus.add_color_override("font_color",Color("36c21b")) #green
		else:
			$MarginContainer/VBoxContainer/CarStatus/GreenLEDBox/GreenLEDStatus.text = "Flashing"
			$MarginContainer/VBoxContainer/CarStatus/GreenLEDBox/GreenLEDStatus.add_color_override("font_color",Color("c21b1b")) #red
	else:
		# both offline
		#red
		$MarginContainer/VBoxContainer/CarStatus/RedLEDBox/RedLEDStatus.text = "Offline"
		$MarginContainer/VBoxContainer/CarStatus/RedLEDBox/RedLEDStatus.add_color_override("font_color",Color("6d000000")) #grey
		
		#green
		$MarginContainer/VBoxContainer/CarStatus/GreenLEDBox/GreenLEDStatus.text = "Offline"
		$MarginContainer/VBoxContainer/CarStatus/GreenLEDBox/GreenLEDStatus.add_color_override("font_color",Color("6d000000")) #grey
