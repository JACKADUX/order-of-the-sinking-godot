class_name Coyote extends Enemy

func check_battle(battle_service:BattleService):
	battle_service.neighbor_attack(get_coords())
