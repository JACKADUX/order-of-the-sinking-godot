class_name MoveService extends Service

var tilemap_manager:TileMapManager
var entity_manager:EntityManager

func _init(_tilemap_manager:TileMapManager, _entity_manager:EntityManager) -> void:
	tilemap_manager = _tilemap_manager
	entity_manager = _entity_manager

func can_move_to_this_coords(entity:Entity, coords:Vector2i) -> bool:
	var target_entity := entity_manager.get_entity_at(coords)
	if target_entity:
		var obstacle :Obstacle = target_entity.get_component(Obstacle)
		if obstacle and obstacle.is_wall():
			return false
	if tilemap_manager.is_wall(coords):
		return false
	if entity is Character:
		return not tilemap_manager.is_water(coords)
	return true

func try_move(entity:Entity, dir:Vector2i) -> bool:
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


func apply_ability(entity:Entity, dir:Vector2i, ability_type:int):
	match ability_type:
		0: push(entity, dir, 1)
		1: push(entity, dir, 9999)
		2: pull(entity, dir)
		3: teleport(entity, dir)
		4: push(entity, dir, 0)
		5: follow(entity, dir)
		6: morph(entity, dir)
		
		8: push(entity, dir, 1)
	
func push(entity:Entity, dir:Vector2i, power:int=0):
	if not can_move_to_this_coords(entity, entity.get_coords() + dir):
		return false
	var target_coords := entity.get_coords()+dir
	var other_entity = entity_manager.get_entity_at(target_coords)
	if not other_entity or try_slide(other_entity, dir, power):
		entity.move_to(target_coords)

func pull(entity:Entity, dir:Vector2i):
	if not can_move_to_this_coords(entity, entity.get_coords() + dir):
		return false
	var current_coords := entity.get_coords()
	var target_coords := current_coords+dir
	var back_coords := current_coords-dir
	var other_entity = entity_manager.get_entity_at(target_coords)
	if other_entity : return 
	entity.move_to(target_coords)
	other_entity = entity_manager.get_entity_at(back_coords)
	if other_entity:
		var obstacle :Obstacle = other_entity.get_component(Obstacle)
		if obstacle and obstacle.is_wall():
			return		
		other_entity.move_to(current_coords)

func teleport(entity:Entity, dir:Vector2i):
	if not can_move_to_this_coords(entity, entity.get_coords() + dir):
		return false
	var current_coords := entity.get_coords()
	var other_entity := entity_manager.get_nearest_entitiy_at_line(entity, dir)
	if other_entity:
		var obstacle :Obstacle = other_entity.get_component(Obstacle)
		if obstacle and obstacle.is_wall():
			return			
		entity.set_coords(other_entity.get_coords())
		other_entity.set_coords(current_coords)
	else:
		entity.move_to(current_coords+dir)
	
func follow(entity:Entity, dir:Vector2i):
	var target_coords := entity.get_coords()+dir
	if not can_move_to_this_coords(entity, target_coords):
		return false
	var other_entity := entity_manager.get_entity_at(target_coords)
	if other_entity:
		var obstacle :Obstacle = other_entity.get_component(Obstacle)
		if obstacle and obstacle.is_wall():
			return	
		if not try_slide(other_entity, dir, 2):
			return 
	entity.move_to(target_coords)
	
		
func morph(entity:Entity, dir:Vector2i):
	var coords := entity.get_coords()+ dir
	var other_entity := entity_manager.get_entity_at(coords)
	if other_entity:
		# NOTE: 变形者特殊的点在于可以把生物属性的 WALL 改为 MOVABLE
		var creature :Creature = other_entity.get_component(Creature)
		var obstacle :Obstacle = other_entity.get_component(Obstacle)
		if creature and obstacle:
			var crystalized := creature.is_crystalized()
			creature.set_crystalize(not crystalized)
		return
	if not can_move_to_this_coords(entity,  coords):
		return 
	entity.move_to(coords)
