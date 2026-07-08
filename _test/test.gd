@tool
extends EditorScript

func _run() -> void:
	
	var m = GroundMovable.new()
	print(m is GroundMovable)
