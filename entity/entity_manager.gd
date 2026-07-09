class_name EntityManager extends Node2D


func raise_event(event:BaseEvent):
	get_tree().call_group(Const.GROUP_ENTITY, "handle_event", event)
	
func get_all_entities() -> Array:
	return get_tree().get_nodes_in_group(Const.GROUP_ENTITY)

const K_CACHE_MOVABLE := "K_CACHE_MOVABLE"
const K_CACHE_WALL := "K_CACHE_WALL"
const K_CACHE_CHARACTER := "K_CACHE_CHARACTER"
const K_CACHE_ENEMY := "K_CACHE_ENEMY"
const K_CACHE_ALL := "K_CACHE_ALL"

var _cache := {} 
func update_coords_entity_cache():
	_cache = create_coords_entity_data()

func query_coords_entity_data(...args) -> Dictionary:
	var data = {}
	for key in args:
		data.merge(_cache.get(key, {}))
	return data

func create_coords_entity_data() -> Dictionary:
	var cache = {
		K_CACHE_MOVABLE:{},
		K_CACHE_WALL:{},
		K_CACHE_CHARACTER:{},
		K_CACHE_ENEMY:{},
	}
	var keys = cache.keys()
	for entity in get_all_entities():
		var health = entity.get_component(Health)
		if health and health.is_dead():
			# NOTE : 有生命值且已经死亡的实体不用获取
			continue
		var obstical :Obstacle = entity.get_component(Obstacle)
		if not obstical:
			continue
		for cache_key:String in keys:
			match cache_key:
				K_CACHE_MOVABLE:
					if not obstical.is_movable() :
						# NOTE : 无有效移动能力的实体不用获取
						continue
				K_CACHE_WALL:
					if not obstical.is_wall():
						continue
				K_CACHE_CHARACTER:
					if entity is not Character or is_crystalized(entity):
						continue
				K_CACHE_ENEMY:
					if entity is not Enemy or is_crystalized(entity):
						continue
			cache[cache_key][entity.get_coords()] = entity
			
	
	cache[K_CACHE_ALL] = {}	
	for cache_key:String in keys:
		cache[K_CACHE_ALL].merge(cache[cache_key],true)
	return cache

func get_entities() -> Array:
	return query_coords_entity_data(K_CACHE_ALL).values()

func get_entity_at(coords:Vector2i) -> Entity: 
	return query_coords_entity_data(K_CACHE_ALL).get(coords) 	
	
func get_movable_entity_at(coords:Vector2i) -> Entity: 
	return query_coords_entity_data(K_CACHE_MOVABLE).get(coords) 

func get_wall_entity_at(coords:Vector2i) -> Entity:
	return query_coords_entity_data(K_CACHE_WALL).get(coords) 

func get_characters() -> Array:
	return query_coords_entity_data(K_CACHE_CHARACTER).values()

func get_character_at(coords:Vector2i) -> Character:
	return query_coords_entity_data(K_CACHE_CHARACTER).get(coords) 

func get_enemies() -> Array:
	return query_coords_entity_data(K_CACHE_ENEMY).values()

func get_nearest_entitiy_at_direction(entity:Entity, dir:Vector2i) -> Entity:
	var coords := entity.get_coords()
	var coords_data := query_coords_entity_data(K_CACHE_ALL)
	var sp := coords+dir
	for i in coords_data.size():
		if coords_data.has(sp):
			return coords_data[sp]
		sp += dir
	return null

func get_neighbor_character(coords:Vector2i) -> Array:
	var data = query_coords_entity_data(K_CACHE_CHARACTER)
	var characters := []
	for v in [Vector2i.LEFT, Vector2i.UP, Vector2i.RIGHT, Vector2i.DOWN]:
		var nei_character = data.get(coords+v)
		if nei_character:
			characters.append(nei_character)
	return characters

func get_entity_at_matrix(coords:Vector2i) -> Array:
	#for entity:Entity in get_coords_entity_data():
		#pass
	return []
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

func is_crystalized(entity:Entity) -> bool:
	var component = entity.get_component(Creature)
	return false if not component else component.is_crystalized()

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
