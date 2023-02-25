extends Control

var connected = false
var serial_data

var battery_voltage
var red_led
var green_led
var solenoid_time

var red_led_flashing
var green_led_flashing

#var com_ports

var time_last
var time_since


# Called when the node enters the scene tree for the first time.
func _ready():
	print( OS.get_unix_time())
	#serial_data = get_tree().get_nodes_in_group("serial_data")[0]

# warning-ignore:unused_argument
func _process(delta):

	
	# get connection status and time_since
	if serial_data:
		# make flashing variables work
		if red_led > 0 and red_led < 1:
			red_led_flashing = true
		else:
			red_led_flashing = false
			
		if green_led > 0 and green_led < 1:
			green_led_flashing = true
		else:
			green_led_flashing = false
		
		time_since = OS.get_unix_time() - int(time_last)
		
		if time_since > 5:
			connected = false
		else:
			connected = true
