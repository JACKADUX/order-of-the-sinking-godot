class_name BuffService extends Service

var tilemap_manager:TileMapManager
var entity_manager:EntityManager

func _init(_tilemap_manager:TileMapManager, _entity_manager:EntityManager) -> void:
	tilemap_manager = _tilemap_manager
	entity_manager = _entity_manager

func update():
	var characters := entity_manager.get_characters()
	for character :Character in characters:
		if is_immunity(character):
			continue
		var coords := character.get_coords()
		var nei_characters = entity_manager.get_neighbor_character(coords)
		var any_immunity := false
		for c in nei_characters:
			if is_immunity.call(c):
				any_immunity = true
				break
		set_immunity(character, any_immunity)

func is_immunity(character:Character):
	var ability :Ability = character.get_component(Ability)
	return ability.type == Ability.Type.IMMUNITY
	
func set_immunity(character:Character, value:bool):
	var healt :Health = character.get_component(Health)
	healt.set_invincible(value)
