class_name LevelManager extends Manager

var _marker_cache :Dictionary[Vector2i, LevelMark]= {}
func init_manager():
	for mark in get_level_marks():
		_marker_cache[get_coords(mark)] = mark

func get_level_marks() -> Array:
	return Engine.get_main_loop().get_nodes_in_group(Const.GROUP_LEVEL_MARK)

func get_level_mark_at(coords:Vector2i) -> LevelMark:
	return _marker_cache.get(coords)

func get_coords(node:Node2D) -> Vector2i:
	return Vector2i(floor(node.global_position / Const.TILE))
