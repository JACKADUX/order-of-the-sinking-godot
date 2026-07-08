class_name Health extends Component

signal health_changed(damage:int)
signal invincible_changed

@export var health_value :int= 1
@export var invincible := false

func take_damage(damage:int):
	if invincible or is_dead():
		return 
	health_value = max(0, health_value-abs(damage))
	health_changed.emit(damage)

func to_death():
	health_value = 0
	health_changed.emit(0)
	
func is_dead() -> bool:
	return health_value <= 0

func get_data() -> Dictionary:
	return super().merged({
		"health_value":health_value,
	},true)
	
func set_data(data:Dictionary):
	super(data)
	health_value = data.get("health_value", health_value)

func set_invincible(value:bool):
	if invincible == value:
		return 
	invincible = value
	invincible_changed.emit()
