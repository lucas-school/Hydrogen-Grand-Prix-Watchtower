extends Control

@onready var chart: Chart = $VBoxContainer/Chart
@onready var serial_data = $serialData

# This Chart will plot 3 different functions

# Let's create our @x values
#var x: Array = ArrayOperations.multiply_float(range(-10, 11, 1), 0.5)


var min_points = 60


var voltage_graph: Function
var update = false

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
	cp.colors.background = Color.TRANSPARENT
	cp.colors.grid = Color("#c3c3c3")
	cp.colors.ticks = Color("#f2f2f2")
	cp.colors.text = Color("#000000")
	cp.draw_bounding_box = false
	cp.title = "Battery Voltage"
	cp.x_label = "Time"
	cp.y_label = "Voltage"
	cp.x_scale = 5
	cp.y_scale = 10
	cp.interactive = true # false by default, it allows the chart to create a tooltip to show point values
	# and interecept clicks on the plot
	
	voltage_graph = Function.new(x, y, "Voltage", { color = Color("#1b1ec2"), type = Function.Type.LINE, marker = Function.Marker.CIRCLE, interpolation = Function.Interpolation.LINEAR })
	
	chart.plot([voltage_graph], cp)


func _process(_delta):
	pass

func push_value_update():
	#("Updating Voltage Graph")
	
	voltage_graph.add_point(round(serial_data.time_since_start), serial_data.battery_voltage)
	var total_x_points = len(voltage_graph.get_points()[0])
	if total_x_points > min_points:
		voltage_graph.remove_first_point()
	chart.update()
