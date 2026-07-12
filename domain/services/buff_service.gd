class_name BuffService extends Service

func update():
	var characters := entity_manager.get_characters()
	for character :Character in characters:
		if is_immunity(character):
			continue
		var coords := character.get_coords()
		var nei_entites = entity_manager.get_neighbor_entities(coords)
		var any_immunity := false
		for c in nei_entites:
			if c is not Character:
				continue
			if is_immunity(c):
				any_immunity = true
				break
		set_invincible(character, any_immunity)
		
func is_immunity(character:Character):
	var ability :Ability = character.get_component(Ability)
	return ability.type == Ability.Type.IMMUNITY
	
func set_invincible(character:Character, value:bool):
	var healt :Health = character.get_component(Health)
	healt.set_invincible(value)
