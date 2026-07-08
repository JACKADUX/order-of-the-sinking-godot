@tool
class_name Mirror extends Node2D


@onready var line_x: Line2D = %LineX
@onready var line_y: Line2D = %LineY
@onready var center: Node2D = %Center

enum MirrorDir {RB,BL,LT,TR}
@export var mirror_dir := MirrorDir.RB:
	set(v):
		mirror_dir = v
		if is_inside_tree():
			update_direction()
			
var miro_normal :=Vector2.ONE.normalized()

var item_x = null
var item_y = null


func _ready() -> void:
	add_to_group(Const.GROUP_MIRROR)
	InputMapUtils.action_add_event_key(Const.IM_ACT, KEY_X)
	update_direction()

func get_data() -> Dictionary:
	return {
		"id":get_instance_id(),
		"global_position":global_position,
	}
func set_data(data:Dictionary):
	global_position = data.get("global_position", global_position)

func update_direction():
	miro_normal = Vector2.ONE.normalized()
	center.rotation_degrees = 0
	match mirror_dir:
		MirrorDir.RB: pass
		MirrorDir.BL: 
			miro_normal = miro_normal.rotated(PI/2)
			center.rotation_degrees = 90
		MirrorDir.LT: 
			miro_normal = miro_normal.rotated(PI)
			center.rotation_degrees = 180
		MirrorDir.TR: 
			miro_normal = miro_normal.rotated(PI/2.*3)
			center.rotation_degrees = 270
		
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(Const.IM_ACT):
		var item = get_pro_item()
		if item: # FIXME: 不要换位置，要生成
			var item_rel_pos :Vector2 = global_transform.affine_inverse()*item.global_position
			item.global_position = global_transform*(item_rel_pos.reflect(miro_normal))
			item.global_position=item.global_position.round()
			
func get_pro_item():
	if item_x and item_y:
		return item_x
	if item_x:
		return item_x
	if item_y:
		return item_y

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return 
	check_mirror()
		
func check_mirror():
	var items = Const.get_movable_items()
	var mirror_pos := Const.grid_position(global_position)
	var minx = 1000
	var miny = 1000
	item_x = null
	item_y = null
	for item in items:
		if item == self:
			continue
		if not at_right_side(item.global_position):
			continue
		var item_pos := Const.grid_position(item.global_position)
		var dist = item_pos - mirror_pos
		if dist.x == 0 and dist.y < miny:
			miny = dist.y
			item_y = item
		if dist.y == 0 and dist.x < minx:
			minx = dist.x
			item_x = item
	
	line_x.visible = item_x != null
	line_y.visible = item_y != null
	
	if item_x:
		var item_center = line_x.global_transform.affine_inverse()*(item_x.global_position+Vector2(16,16))
		line_x.set_point_position(1,item_center)
	if item_y:
		var item_center = line_y.global_transform.affine_inverse()*(item_y.global_position+Vector2(16,16))
		line_y.set_point_position(1,item_center)
	
func at_right_side(pos:Vector2):
	var rel = (pos-global_position).normalized()
	var ang = round(rad_to_deg(abs(rel.angle_to(miro_normal))))
	return ang <= 45

func is_valied_teleport(_posi:Vector2i) -> bool:
	return true
