from godot import exposed, export
from godot import *
import serial
import sys
import glob

#ser = serial.Serial('COM6', 115200, timeout=.1)

@exposed
class readSerial(Control):

	# member variables here, example:
	a = export(int)
	b = export(str, default='foo')
	ser = export(str, default='disconnected')
	
	def serial_ports(self):
		""" Lists serial port names

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
		#print(serial_ports())
	
	def _process(self, delta):
		#print(ser.readline())
		print(self.serial_ports())
	

