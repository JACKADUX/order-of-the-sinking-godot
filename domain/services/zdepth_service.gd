class_name ZDepthService extends Service

# NOTE: 考虑到像素游戏视角的限制，只有三个高度 1 墙上，0 地面，-1 水里

func update() -> void:
	var coords_data = entity_manager.query_coords_entity_data(EntityManager.K_CACHE_MOVABLE)
	var under_water_data = entity_manager.query_coords_entity_data(EntityManager.K_CACHE_UNDER_WATER)
	for coords in coords_data:
		var entity :Entity = coords_data[coords]
		if tilemap_manager.is_water(coords) and entity.get_zdepth() >= 0:
			var under_water_entity = under_water_data.get(coords)
			var supportable = entity_manager.is_supportable(under_water_entity)
			if under_water_entity and supportable:
				# NOTE: 支撑物跳过
				continue
			if under_water_entity and not supportable:
				# NOTE: 这里是非生命物体的毁坏。比如后续的镜子可以在水里，但是上面有物体就会毁坏。
				under_water_entity.get_component(Health).to_death()
				
			entity.set_zdepth(-1)
			var health :Health = entity.get_component(Health)
			if health.is_attackable():
				health.to_death()
				continue
			var obstacle :Obstacle = entity.get_component(Obstacle)
			obstacle.set_type(Obstacle.Type.GHOST)
