class_name TileMapManager extends Manager

@export var ground_tilemap :TileMapLayer
@export var wall_tilemap : TileMapLayer

const EMPTY :int = 0
const WALL :int = 1
const GROUND :int = 2
const WATER :int = 3

func get_type_data(tilemaplayer:TileMapLayer, coords: Vector2i)->int:
	var data = tilemaplayer.get_cell_tile_data(coords)
	return 0 if not data else data.get_custom_data("type")

func is_wall(coords: Vector2i) -> bool:
	return get_type_data(wall_tilemap, coords) == WALL
	
func is_water(coords: Vector2i) -> bool:
	return get_type_data(ground_tilemap, coords) == WATER


func set_water_to_ground(coords: Vector2i):
	ground_tilemap.set_cell(coords, 0, Vector2i(1,0))
