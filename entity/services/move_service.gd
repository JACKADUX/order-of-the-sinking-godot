class_name MoveService extends Service

var tilemap_manager:TileMapManager
var entity_manager:EntityManager

func _init(_tilemap_manager:TileMapManager, _entity_manager:EntityManager) -> void:
	tilemap_manager = _tilemap_manager
	entity_manager = _entity_manager

func try_move(entity:Entity, dir:Vector2i) -> bool:
	if not can_move_to_this_coords(entity, entity.get_coords() + dir):
		return false
	var ability = entity.get_component(Ability)
	if not ability:
		return false
	apply_ability(entity, dir, ability.type)
	return true
	
func try_slide(entity:Entity, dir:Vector2i, max_iter:int=1) -> bool:
	if max_iter <= 0:
		return false
	if not can_move_to_this_coords(entity, entity.get_coords() + dir):
		return false
	max_iter -= 1
	var target_coords := entity.get_coords()+dir
	var _entity = entity_manager.get_entity_at(target_coords)
	if not _entity or try_slide(_entity, dir, max_iter):
		entity.move_to(target_coords)
		return true
	return false
	
func can_move_to_this_coords(entity:Entity, coords:Vector2i) -> bool:
	var movable :Movable = entity.get_component(Movable)
	if not movable:
		return true
	if not movable.is_movable() or tilemap_manager.is_wall(coords):
		return false
	if entity is Character:
		return not tilemap_manager.is_water(coords)
	return true


func apply_ability(entity:Entity, dir:Vector2i, ability_type:int):
	match ability_type:
		0: push(entity, dir, 0)
		1: push(entity, dir, 9999)
		2: pull(entity, dir)
		3: teleport(entity, dir)
		4: push(entity, dir, 0)
		5: push(entity, dir, 0)
		6: morph(entity, dir)
		
		8: push(entity, dir, 1)
	
func push(entity:Entity, dir:Vector2i, power:int=0):
	var target_coords := entity.get_coords()+dir
	var other_entity = entity_manager.get_entity_at(target_coords)
	if not other_entity or try_slide(other_entity, dir, power):
		entity.move_to(target_coords)

func pull(entity:Entity, dir:Vector2i):
	var current_coords := entity.get_coords()
	var target_coords := current_coords+dir
	var back_coords := current_coords-dir
	var other_entity = entity_manager.get_entity_at(target_coords)
	if other_entity : return 
	entity.move_to(target_coords)
	other_entity = entity_manager.get_entity_at(back_coords)
	if other_entity:
		other_entity.move_to(current_coords)

func teleport(entity:Entity, dir:Vector2i):
	var current_coords := entity.get_coords()
	var other_entity := entity_manager.get_nearest_entitiy_at_line(entity, dir)
	if other_entity:
		entity.set_coords(other_entity.get_coords())
		other_entity.set_coords(current_coords)
	else:
		entity.move_to(current_coords+dir)

func morph(entity:Entity, dir:Vector2i):
	var current_coords := entity.get_coords()
	var other_entity := entity_manager.get_entity_at(current_coords+dir)
	if other_entity :
		if other_entity.has_component(Creature):
			var movable :Movable = other_entity.get_component(Movable)
			movable.set_obstacle(not movable.obstacle)
	else:
		entity.move_to(current_coords+dir)
