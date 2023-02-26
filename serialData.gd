extends Control

var connected = false
var serial_data

var battery_voltage = 0.00
var red_led
var green_led
var solenoid_time

var red_led_flashing
var green_led_flashing

#var com_ports

var time_last #unix time of last ping
var time_since #time since last ping

var time_since_start #time since very first reception
var time_started = 0 #time of very first reception
var started = false

var update_voltage_graph = false
var update_fuel_cell_graph = false
onready var update_once = true

###

var graphs
# Called when the node enters the scene tree for the first time.
func _ready():
	graphs = get_tree().get_nodes_in_group("graphs")
	#serial_data = get_tree().get_nodes_in_group("serial_data")[0]

# warning-ignore:unused_argument
func _process(delta):
	
	# store start time
	if started == false and connected:
		time_started = OS.get_unix_time()
		started = true
	
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
		
		#calculate if still connected
		if time_since > 5:
			connected = false
		else:
			connected = true
			
		# calculate time since first connected
		time_since_start = OS.get_unix_time() - time_started
		if time_since_start == OS.get_unix_time():
			time_since_start = 0
			
		# prevent weird graph formations
		time_since_start += 1
		
		
		print(time_since_start)
		# push updates to graphs
		if time_last == OS.get_unix_time() and update_once and battery_voltage is float:
			for graph in graphs:
				graph.push_value_update()
			update_once = false
		else:
			update_once = true
