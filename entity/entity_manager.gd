class_name EntityManager extends Node2D


func raise_event(event:BaseEvent):
	get_tree().call_group(Const.GROUP_ENTITY, "handle_event", event)
	
func get_all_entities() -> Array:
	return get_tree().get_nodes_in_group(Const.GROUP_ENTITY)

func get_tagetable_entites() -> Array:
	# NOTE: 这里只会返回有效实体
	var entities := []
	for entity in get_all_entities():
		var obstical :Obstacle = entity.get_component(Obstacle)
		if not obstical or obstical.is_ghost():
			# NOTE : 无有效移动能力的实体不用获取
			continue
		var health = entity.get_component(Health)
		if health and health.is_dead():
			# 有生命值且已经死亡的实体不用获取
			continue
		entities.append(entity)
	return entities

func get_entity_at(coords:Vector2i) -> Entity: 
	for entity :Entity in get_tagetable_entites():
		if coords == entity.get_coords():
			return entity
	return null 

func has_entity_at(posi:Vector2i) -> bool:
	return get_entity_at(posi) != null

func get_characters() -> Array:
	var characters = get_tree().get_nodes_in_group(Const.GROUP_CHARACTER)
	return characters.filter(func(c): return not is_dead(c))

func get_character_at(coords:Vector2i) -> Character:
	for character:Character in get_characters():
		if coords == character.get_coords():
			return character
	return null

func get_enemies() -> Array:
	var enemies = get_tree().get_nodes_in_group(Const.GROUP_ENEMY)
	return enemies.filter(func(c): return not is_dead(c))

func get_entities_at_line(src_entity:Entity, dir_norm:Vector2, tolerance:float=0.001) -> Dictionary:
	var ent := []
	var nearest : Entity
	var dist = 10000
	var origin = Vector2(src_entity.get_coords())
	for entity:Entity in get_tagetable_entites():
		if src_entity == entity:
			continue
		var point = Vector2(entity.get_coords())
		var v = point-origin
		var t = v.dot(dir_norm)
		if t < 0:
			continue
		var closest_point = origin + dir_norm * t
		if not point.distance_to(closest_point) <= tolerance:
			continue
		ent.append(entity)
		var l = v.length()
		if l < dist:
			dist = l
			nearest = entity
	return {"entities": ent, "nearest":nearest}

func get_nearest_entitiy_at_line(entity:Entity, dir_norm:Vector2i) -> Entity:
	var data = get_entities_at_line(entity, dir_norm, 0.001)
	return data.nearest

func get_neighbor_character(coords:Vector2i) -> Array:
	var characters := []
	for v in [Vector2i.LEFT, Vector2i.UP, Vector2i.RIGHT, Vector2i.DOWN]:
		var nei_character = get_character_at(coords+v)
		if nei_character:
			characters.append(nei_character)
	return characters



## Mechanism
func get_triggers() -> Array:
	return get_tree().get_nodes_in_group(Const.GROUP_MECHANISM_TRIGGER)

func get_actuators() -> Array:
	return get_tree().get_nodes_in_group(Const.GROUP_MECHANISM_ACTUATOR)


## Utils
func get_character_index(character:Character) -> int:
	return int(character.get_component(Ability).get_type())
	
func is_dead(entity:Entity) -> bool:
	var health = entity.get_component(Health)
	return false if not health else health.is_dead()

func get_active_characters() -> Array:
	return get_characters().filter(
		func(c): return c.get_component(Activate).is_activated()
	)
	
func character_activate(index:int):
	for character :Character in get_characters():
		var active = character.get_component(Ability).type == index
		character.get_component(Activate).set_activate(active)
	
	
func get_valid_character_indexs() -> Array:
	# NOTE: 有效的依次排序的角色序号列表 -> 比如只有角色2和角色5就是 [2,5] 
	var d := {}
	for character:Character in get_characters():
		d[get_character_index(character)] = true
	var indexs = d.keys()
	indexs.sort() 
	return indexs
