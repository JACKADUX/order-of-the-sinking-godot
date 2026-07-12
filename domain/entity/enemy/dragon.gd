class_name Dragon extends Enemy

func check_battle(battle_service:BattleService):
	battle_service.line_attack(get_coords(), get_direction())
