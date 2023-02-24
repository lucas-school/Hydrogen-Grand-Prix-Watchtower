extends Control

onready var chart: Chart = $VBoxContainer/Chart

# This Chart will plot 3 different functions

var voltage_graph: Function

func _ready():
	# Let's create our @x values
	var x: Array = ArrayOperations.multiply_float(range(-10, 11, 1), 0.5)
	
	# And our y values. It can be an n-size array of arrays.
	# NOTE: `x.size() == y.size()` or `x.size() == y[n].size()`
	var y2: Array = ArrayOperations.add_float(ArrayOperations.multiply_int(ArrayOperations.sin(x), 20), 20)
	
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
	cp.y_label = "Hydrogen"
	cp.x_scale = 5
	cp.y_scale = 10
	cp.interactive = true # false by default, it allows the chart to create a tooltip to show point values
	# and interecept clicks on the plot
	
	voltage_graph = Function.new(x, y2, "Hydrogen", { color = Color("#1bc2b6"), type = Function.Type.LINE, marker = Function.Marker.CROSS, interpolation = Function.Interpolation.SPLINE })
	
	# Now let's plot our data
	chart.plot([voltage_graph], cp)
	
	# Uncommenting this line will show how real time data plotting works
	set_process(false)


var new_val: float = 4.5

func _process(delta: float):
	# This function updates the values of a function and then updates the plot
	new_val += 5
	
	# we can use the `Function.add_point(x, y)` method to update a function

	voltage_graph.add_point(new_val, (sin(new_val) * 20) + 20)
	chart.update() # This will force the Chart to be updated


func _on_CheckButton_pressed():
	set_process(not is_processing())
