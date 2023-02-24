from godot import exposed, export
from godot import *
import serial


@exposed
class readSerial(Control):

	# member variables here, example:
	a = export(int)
	b = export(str, default='foo')

	def _ready(self):
		serial.Serial()
