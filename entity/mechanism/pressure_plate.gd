class_name PressurePlate extends MechanismTrigger

@onready var sprite_2d: Sprite2D = %Sprite2D

func update() -> void:
	sprite_2d.texture.x = 1 if is_activated() else 0


	
