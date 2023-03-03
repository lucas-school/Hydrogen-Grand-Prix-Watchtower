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

var time_since_start = 0 #time since very first reception
var time_started = 0 #time of very first reception
var started = false

var update_voltage_graph = false
var update_fuel_cell_graph = false
onready var update_once = true
var last_push = 0

###
#CHANGE IF EVER CHANGED
var time_between_data = 5

var graphs

onready var serial_data_file = 'res://python/temp/temp'


# Called when the node enters the scene tree for the first time.
func _ready():
	graphs = get_tree().get_nodes_in_group("graphs")

	#serial_data = get_tree().get_nodes_in_group("serial_data")[0]
func load_file(file):

	var f = File.new()
	f.open(file, File.READ)
	var index = 1
	var line
	while not f.eof_reached(): # iterate through all lines until the end of file is reached
		line = f.get_line()
		line += " "

		index += 1
	f.close()
	return line



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
		
		
		#(time_since_start)
		# push updates to graphs
		if time_last == OS.get_unix_time() and update_once and battery_voltage is float and OS.get_unix_time() - last_push > time_between_data + 1 and time_since_start > 0:
			last_push = OS.get_unix_time()
			for graph in graphs:
				graph.push_value_update()
			update_once = false
		else:
			update_once = true

# check temp file for serial data and update variables
func _on_checkSerialTimer_timeout():
	# on timer timeout,load from temp file
	var serial_raw = load_file(serial_data_file)
	
	# seperate into a list
	var serial_raw_sep = serial_raw.split(",")
	
	# update variables
	serial_data = serial_raw
	battery_voltage = float(serial_raw_sep[1])
	red_led = float(serial_raw_sep[2])
	green_led = float(serial_raw_sep[3])
	solenoid_time = int(serial_raw_sep[4])
	time_last = int(serial_raw_sep[0])
