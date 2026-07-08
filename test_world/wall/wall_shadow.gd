extends TileMapLayer

var wall_layer :TileMapLayer

func _ready() -> void:
	wall_layer = get_parent()
	update()
	
		
func update():
	var cells = wall_layer.get_used_cells()
	for cell in cells:
		var tile_data = wall_layer.get_cell_tile_data(cell)
		var type = tile_data.get_custom_data("type")
		if type != 1:
			continue
		
		var t_tile = cell + Vector2i(0,-1)
		var r_tile = cell + Vector2i(1,0)
		var l_tile = cell + Vector2i(-1,0)
		var b_tile = cell + Vector2i(0,1)
		var lb_tile = cell + Vector2i(-1,1)
		var t_empty = wall_layer.get_cell_source_id(t_tile) == -1
		var r_empty = wall_layer.get_cell_source_id(r_tile) == -1
		var l_empty = wall_layer.get_cell_source_id(l_tile) == -1
		var b_empty = wall_layer.get_cell_source_id(b_tile) == -1
		if l_empty :
			if get_cell_source_id(l_tile) == -1:
				if t_empty:
					set_cell(l_tile, 1, Vector2i(0,6))
				else:
					set_cell(l_tile, 1, Vector2i(0,7))
			else:
				set_cell(l_tile, 1, Vector2i(1,7))
		if b_empty:
			if get_cell_source_id(b_tile) == -1:
				if r_empty:
					set_cell(b_tile, 1, Vector2i(2,8))	
				else:
					set_cell(b_tile, 1, Vector2i(1,8))	
			else:
				set_cell(b_tile, 1, Vector2i(1,7))
		if wall_layer.get_cell_source_id(lb_tile) == -1 and l_empty and b_empty:
			set_cell(lb_tile, 1, Vector2i(0,8))
