class_name Const extends RefCounted

const TILE := 32

const IM_MOVE := "MOVE"
const IM_LEFT := "LEFT"
const IM_RIGHT := "RIGHT"
const IM_UP := "UP"
const IM_DOWN := "DOWN"

const IM_RESET := "RESET" # R
const IM_UNDO := "UNDO" # Z
const IM_ACTION := "ACTION" # X
const IM_SWITCH_CHARACTER := "SWITCH_CHARACTER"  # C
const IM_ENTER_LEVEL := "ENTER_LEVEL"  # V

const GROUP_ENTITY := "GROUP_ENTITY"
const GROUP_CHARACTER := "GROUP_CHARACTER"
const GROUP_ENEMY := "GROUP_ENEMY"

const GROUP_MECHANISM_TRIGGER := "GROUP_MECHANISM_TRIGGER"  # 触发器
const GROUP_MECHANISM_ACTUATOR := "GROUP_MECHANISM_ACTUATOR" # 执行器

const GROUP_LEVEL_MARKER := "GROUP_LEVEL_MARKER"


#static func get_level_markers() -> Array:
	#return Engine.get_main_loop().get_nodes_in_group(GROUP_LEVEL_MARKER)
#
#static func get_level_marker_at(coords:Vector2i) -> LevelMarker:
	#for marker in get_level_markers():
		#if get_coords(marker.global_position) == coords:
			#return marker
	#return null
		
