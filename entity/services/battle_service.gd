class_name BattleService extends Service

var entity_manager:EntityManager

func _init(_entity_manager:EntityManager) -> void:
	entity_manager = _entity_manager
	
func update():
	var characters := entity_manager.get_characters()
	var enemies := entity_manager.get_enemies()
	var all_targets := enemies+characters
	
	for enemy:Enemy in enemies:
		for target :Entity in all_targets:
			if target == enemy:
				continue
			line_hurt(enemy, target)
			
func simple_hurt(enemy:Enemy, target_entity:Entity):
	if Vector2(target_entity.get_coords()-enemy.get_coords()).length() <= 1:
		target_entity.get_component(Health).take_damage(1)

func line_hurt(enemy:Enemy, target_entity:Entity):
	if entity_manager.get_nearest_entitiy_at_line(enemy, Vector2i.UP) == target_entity:
		target_entity.get_component(Health).take_damage(1)
