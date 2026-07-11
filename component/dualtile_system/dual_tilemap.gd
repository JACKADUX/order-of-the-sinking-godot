class_name DualTilemapLayer extends TileMapLayer
@warning_ignore_start("integer_division")

const CHECK_LIST  := [Vector2i(1,1),Vector2i(0,1),Vector2i(1,0),Vector2i(0,0)]
const BIT_DATA :Dictionary[int,int]= {
	2:0, 5:1, 11:2, 3:3,
	9:4, 7:5, 15:6, 14:7,
	4:8, 12:9, 13:10, 10:11,
	0:12, 1:13, 6:14, 8:15
}

@export var source_id:int =0
@export var dual_start:Vector2i
@export var custom_data_name:="dual"

func _ready() -> void:
	update()
	
func update():
	var data = {}
	for cell in get_used_cells():
		data[cell] = get_finel_cell(cell)
	for cell in data:
		set_cell(cell, source_id, data[cell])
	position = Vector2(tile_set.tile_size / 2)
	
func get_dual_type(cell:Vector2i) -> int:
	var data = get_cell_tile_data(cell)
	return data.get_custom_data(custom_data_name) if data else 0

func get_finel_cell(cell:Vector2i):
	# 0b1111 <- 从左到右1依次是左上 右上 左下 右下
	var bit = 0
	for i in CHECK_LIST.size():
		var type = get_dual_type(cell+CHECK_LIST[i])
		if type == 1:
			bit |= 1<<i
	var final_index := BIT_DATA[bit]
	var final_offset := Vector2i(final_index%4, final_index/4)
	return dual_start+final_offset
