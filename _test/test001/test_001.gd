extends Node2D
@onready var spin_box: SpinBox = $SpinBox

func _process(delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	var x = 32
	var y = 32
	
	draw_rect(Rect2(10,10,x,y), Color.AQUAMARINE, false, 2)
	
	#var spi = acos(sqrt(2)- 1)
	#var t = 2/tan(spi)
	#prints(rad_to_deg(spi),x*t)
	#draw_rect(Rect2(20+x,10,x,x*t), Color.AQUAMARINE, false, 2)
	var ang = deg_to_rad(spin_box.value)
	var spx = sin(ang)
	var fy = round(x*spx)
	draw_rect(Rect2(20+x,10,x,fy), Color.AQUAMARINE, false, 2)
	prints(x, fy)
