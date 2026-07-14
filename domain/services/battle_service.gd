class_name BattleService extends Service

func update():
	for enemy:Enemy in entity_manager.get_enemies():
		enemy.check_battle(self)

func attack(entity:Entity, damage:int=1) -> bool:
	if not entity:
		return false
	var health :Health= entity.get_component(Health)
	if not health or not health.is_attackable():
		return false
	health.take_damage(damage)
	return true
	
func neighbor_attack(coords:Vector2i):
	for entity:Entity in entity_manager.get_neighbor_entities(coords):
		attack(entity)

func line_attack(coords:Vector2i, dir:Vector2i):
	var entity = entity_manager.get_nearest_entitiy_at_direction(coords, dir, tilemap_manager)
	attack(entity)
