from godot import exposed, export
from godot import *

global a
a = "test"


@exposed
class Control(Control):



	def _ready(self):
		"""
		Called every time the node is added to the scene.
		Initialization here.
		"""
		pass
	
	def _process(delta, self):
		variable = export(str,a)
		print(a)
