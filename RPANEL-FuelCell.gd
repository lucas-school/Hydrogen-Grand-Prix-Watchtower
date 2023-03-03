extends Control

onready var serial_data = $serialData


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	$MarginContainer/VBoxContainer/CarStatus/H2RemainingBox/H2RemainingAmount.text = str(serial_data.hydrogen_remaining_percent) + "%"
	$MarginContainer/VBoxContainer/CarStatus/H2RemainingBox/H2RemainingAmount.add_color_override("font_color",Color("1bc2b6")) #blue
