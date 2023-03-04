extends Control

onready var serial_data = $serialData

func _ready():
	pass
	
func _process(delta):
	
	# connection status
	if serial_data.connected:
		$MarginContainer/VBoxContainer/ESP32Status/ConnectionBox/ConnectionStatus.text = "Connected"
		$MarginContainer/VBoxContainer/ESP32Status/ConnectionBox/ConnectionStatus.add_color_override("font_color",Color("36c21b")) #green
		
		# last ping
		$MarginContainer/VBoxContainer/ESP32Status/LastPingBox/LastPingSec.text = str(serial_data.time_since) + "s ago"
		
		# update raw data
		$MarginContainer/VBoxContainer/ESP32Raw/MarginContainer/HBoxContainer/MarginContainer/MarginContainer/RawData.text = serial_data.serial_data
	else:
		$MarginContainer/VBoxContainer/ESP32Status/ConnectionBox/ConnectionStatus.text = "Disconnected"
		$MarginContainer/VBoxContainer/ESP32Status/ConnectionBox/ConnectionStatus.add_color_override("font_color",Color("c21b1b")) #red
		$MarginContainer/VBoxContainer/ESP32Status/LastPingBox/LastPingSec.text = "Disconnected"
	


func _on_LogButton_pressed():
	OS.shell_open("file://python/logs")

