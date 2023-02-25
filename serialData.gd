extends Control

var connected = false
var serial_data

var battery_voltage
var red_led
var green_led
var solenoid_time

#var com_ports

var time_last
var time_since

# Called when the node enters the scene tree for the first time.
func _ready():
	print( OS.get_unix_time())
	#serial_data = get_tree().get_nodes_in_group("serial_data")[0]

func _process(delta):
	if serial_data:
		time_since = OS.get_unix_time() - time_last
		
		if time_since > 5:
			connected = false
		else:
			connected = true
