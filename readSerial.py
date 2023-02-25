from godot import exposed, export
from godot import *
import serial

# For reading comm ports
import sys
import glob

# For log
import csv
import time

ser = serial.Serial('COM6', 115200, timeout=.1)
ser_data_list = []
global ser_data 
ser_data = ""

@exposed
class readSerial(Control):
	
	def serial_ports(self):
		""" 
			Lists serial port names

			:raises EnvironmentError:
				On unsupported or unknown platforms
			:returns:
				A list of the serial ports available on the system
		"""
		if sys.platform.startswith('win'):
			ports = ['COM%s' % (i + 1) for i in range(256)]
		elif sys.platform.startswith('linux') or sys.platform.startswith('cygwin'):
			# this excludes your current terminal "/dev/tty"
			ports = glob.glob('/dev/tty[A-Za-z]*')
		elif sys.platform.startswith('darwin'):
			ports = glob.glob('/dev/tty.*')
		else:
			raise EnvironmentError('Unsupported platform')

		result = []
		for port in ports:
			try:
				s = serial.Serial(port)
				s.close()
				result.append(port)
			except (OSError, serial.SerialException):
				pass
		return result


	def _ready(self):
		print(ser)
	
	
	def _process(self, delta):
		# data to always send
		serial_data_nodes = self.get_tree().get_nodes_in_group("serial_data")
		for node in serial_data_nodes:
			#node.com_ports = serial_ports()
			pass
		
		
		# decoding serial data
		global ser_data
		ser_data = ser.readline().decode()
		ser_data_list = []
		tempstr = ""
		
		# remove letters from string
		for char in ser_data:
			if not char.isalpha():
				tempstr += char
		ser_data = tempstr
		
		
		if ser_data:
			ser_data_list = ser_data.split(" ")
		
		#ser_data = export(str,ser_data)
		if ser_data_list:
			
			# send data to another node coded in godot
			serial_data_nodes = self.get_tree().get_nodes_in_group("serial_data")
			for node in serial_data_nodes:
				node.serial_data = ser_data.strip()
				node.battery_voltage = float(ser_data_list[0])
				node.red_led = int(ser_data_list[1])
				node.green_led = int(ser_data_list[2])
				node.solenoid_time = ser_data_list[3]
				node.time_last = int(time.time())

