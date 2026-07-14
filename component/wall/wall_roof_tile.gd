extends TileMapLayer

var wall_map:TileMapLayer

func _ready() -> void:
	wall_map = get_parent()
	update()

func update():
	var cells = PackedVector2Array(wall_map.get_used_cells())
	var up_cells = Transform2D().translated(Vector2(0,-1))*cells
	set_cells_terrain_connect(up_cells, 0, 0)
	
