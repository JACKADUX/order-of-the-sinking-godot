class_name EntityManager extends Node2D

func get_entites() -> Array:
	var entities := []
	for entity in get_tree().get_nodes_in_group(Const.GROUP_ENTITY):
		if not entity.has_component(Movable):
			continue
		var health = entity.get_component(Health)
		if health and health.is_dead():
			continue
		entities.append(entity)
	return entities

func get_entity_at(coords:Vector2i) -> Entity: 
	# NOTE: 这里只会返回包含 Movable 组件的实体
	for entity :Entity in get_entites():
		if coords == entity.get_coords():
			return entity
	return null 

func has_entity_at(posi:Vector2i) -> bool:
	return get_entity_at(posi) != null

func get_characters() -> Array:
	var characters = get_tree().get_nodes_in_group(Const.GROUP_CHARACTER)
	return characters.filter(func(c): return not c.is_dead())

func get_character_at(coords:Vector2i) -> Character:
	for character:Character in get_characters():
		if coords == character.get_coords():
			return character
	return null

func get_enemies() -> Array:
	var enemies = get_tree().get_nodes_in_group(Const.GROUP_ENEMY)
	return enemies.filter(func(c): return not c.is_dead())

func get_entities_at_line(src_entity:Entity, dir_norm:Vector2, tolerance:float=0.001) -> Dictionary:
	var ent := []
	var nearest : Entity
	var dist = 10000
	var origin = Vector2(src_entity.get_coords())
	for entity:Entity in get_entites():
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
