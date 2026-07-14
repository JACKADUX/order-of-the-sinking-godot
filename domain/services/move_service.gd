class_name MoveService extends Service


func can_move_to_this_coords(entity:Entity, coords:Vector2i) -> bool:
	match entity.get_zdepth():
		0:
			if tilemap_manager.is_wall(coords) or entity_manager.get_wall_entity_at(coords):
				return false
			var under_water_entity = entity_manager.get_under_water_entity(coords)
			if tilemap_manager.is_water(coords) and under_water_entity and entity_manager.is_supportable(under_water_entity):
				return true
			if entity is Character:
				return not tilemap_manager.is_water(coords)
		-1: 
			if not tilemap_manager.is_water(coords) or entity_manager.get_under_water_entity(coords):
				return false
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

func try_slide_without_move(entity:Entity, dir:Vector2i, max_iter:int=1) -> bool:
	if max_iter <= 0:
		return false
	if not can_move_to_this_coords(entity, entity.get_coords() + dir):
		return false
	max_iter -= 1
	var target_coords := entity.get_coords()+dir
	var _entity = entity_manager.get_entity_at(target_coords)
	if not _entity or try_slide_without_move(_entity, dir, max_iter):
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
		entity.set_direction(dir)

func pull(entity:Entity, dir:Vector2i):
	if not can_move_to_this_coords(entity, entity.get_coords() + dir):
		return false
	var current_coords := entity.get_coords()
	var target_coords := current_coords+dir
	var back_coords := current_coords-dir
	var other_entity = entity_manager.get_entity_at(target_coords)
	if other_entity : return 
	entity.set_direction(dir)
	entity.move_to(target_coords)
	other_entity = entity_manager.get_movable_entity_at(back_coords)
	if other_entity:
		other_entity.move_to(current_coords)
		

func teleport(entity:Entity, dir:Vector2i):
	var coords := entity.get_coords()
	var target_coords := coords+dir
	if not can_move_to_this_coords(entity, target_coords):
		return false
	var other_entity := entity_manager.get_nearest_entitiy_at_direction(coords, dir, tilemap_manager)
	if other_entity:
		var obstacle :Obstacle = other_entity.get_component(Obstacle)
		if not obstacle.is_wall():
			entity.teleport(other_entity.get_coords())
			other_entity.teleport(coords)
			entity.set_direction(dir)
			return 
	entity.move_to(target_coords)
	entity.set_direction(dir)

func follow(entity:Entity, dir:Vector2i, offset:=Vector2i(2,2)):
	var coords := entity.get_coords()
	var target_coords := coords+dir
	if not can_move_to_this_coords(entity, target_coords):
		return false
	var v_dir := Vector2(dir)
	var matrix_size = offset*2
	var matrix_length = Vector2(matrix_size).dot(v_dir)
	var ori = coords - offset
	# NOTE: 简单来说就是获取矩阵内每个格子在其前方有多少格子
	var _get_slide_count_fn = func(c:Vector2i) -> int:
		var v1_length = Vector2(c-ori).dot(v_dir)
		return abs(v1_length) if matrix_length < 0 else matrix_length - v1_length 
	var other_entity := entity_manager.get_movable_entity_at(target_coords)
	if other_entity and not try_slide_without_move(other_entity, dir, _get_slide_count_fn.call(coords)):
		# NOTE: 假装能推2格，成功就说明能往前走
		return 
	var matrix_entities := entity_manager.get_entities_at_matrix(coords, offset)
	var move_entities := []
	for matrix_entity in matrix_entities:
		# NOTE: try_slide会从前面算，所以需要补偿+1
		var slide_count = _get_slide_count_fn.call(matrix_entity.get_coords())+1
		#prints(matrix_entity,slide_count, try_slide_without_move(matrix_entity, dir, slide_count))
		if try_slide_without_move(matrix_entity, dir, slide_count):
			move_entities.append(matrix_entity)
			
	# NOTE: 因为cache不会实时刷新，所以需要在计算完成后统一移动，否则会出错
	for move_entity in move_entities:	
		move_entity.move_to(move_entity.get_coords()+dir)
	entity.set_direction(dir)

func morph(entity:Entity, dir:Vector2i):
	var coords := entity.get_coords()+ dir
	var other_entity := entity_manager.get_movable_entity_at(coords)
	if not other_entity:
		other_entity = entity_manager.get_wall_entity_at(coords)
	if other_entity:
		# NOTE: 变形者特殊的点在于可以把生物属性的 WALL 改为 MOVABLE
		var creature :Creature = other_entity.get_component(Creature)
		var obstacle :Obstacle = other_entity.get_component(Obstacle)
		if creature and obstacle:
			var crystalized := creature.is_crystalized()
			creature.set_crystalize(not crystalized)
			obstacle.set_supportable(not crystalized)
			entity.set_direction(dir)
		return
	if not can_move_to_this_coords(entity,  coords):
		return 
	entity.move_to(coords)
	entity.set_direction(dir)
	
