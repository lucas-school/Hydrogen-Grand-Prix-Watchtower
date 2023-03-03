extends Control

onready var chart: Chart = $VBoxContainer/Chart
onready var serial_data = $serialData

var min_points = 60


var h2_graph: Function
var update = false # ensure only run updates once


func _ready():

	var x: Array = [0]
	var y: Array = [0]
	# And our y values. It can be an n-size array of arrays.
	# NOTE: `x.size() == y.size()` or `x.size() == y[n].size()`
	#var y: Array = ArrayOperations.add_float(ArrayOperations.multiply_int(ArrayOperations.sin(x), 20), 20)
	
	# Let's customize the chart properties, which specify how the chart
	# should look, plus some additional elements like labels, the scale, etc...
	var cp: ChartProperties = ChartProperties.new()
	cp.colors.frame = Color("#fff")
	cp.colors.background = Color.transparent
	cp.colors.grid = Color("#c3c3c3")
	cp.colors.ticks = Color("#f2f2f2")
	cp.colors.text = Color("#000000")
	cp.draw_bounding_box = false
	cp.title = "Hydrogen Remaining"
	cp.x_label = "Time"
	cp.y_label = "H2"
	cp.x_scale = 5
	cp.y_scale = 10
	cp.interactive = true # false by default, it allows the chart to create a tooltip to show point values
	# and interecept clicks on the plot
	
	h2_graph = Function.new(x, y, "Hydrogen", { color = Color("#1bc2b6"), type = Function.Type.LINE, marker = Function.Marker.CIRCLE, interpolation = Function.Interpolation.LINEAR })
	
	# Now let's plot our data
	chart.plot([h2_graph], cp)


var new_val: float = 4.5

func _process(delta: float):
	pass
		

func push_value_update():
	#("Updating Voltage Graph")
	h2_graph.add_point(round(serial_data.time_since_start), serial_data.hydrogen_remaining_percent)
	var total_x_points = len(h2_graph.get_points()[0])
	if total_x_points > min_points:
		h2_graph.remove_first_point()
	chart.update()
