extends Camera2D



func _process(_delta: float) -> void:
	var application := GameManager.application
	if not application:
		return 
	var characters = application.entity_manager.get_active_characters()
	if not characters:
		return 
	var target = characters[0]
	global_position = (target.global_position / (Const.TILE*10)).floor()*Const.TILE*10-Vector2.ONE*Const.TILE
