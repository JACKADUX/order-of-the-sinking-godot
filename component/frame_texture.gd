@tool
class_name IndexTexture2D extends AtlasTexture

@export var x :int= 0:
	set(v):
		x = v
		_update()
@export var y :int= 0:
	set(v):
		y = v
		_update()
		
@export var tile_size :int = 32:
	set(v):
		tile_size = max(1, v)
		_update()

func _update():
	if not atlas:
		return
	region = Rect2(x * tile_size, y * tile_size, tile_size, tile_size)
	emit_changed()
	notify_property_list_changed()
	
