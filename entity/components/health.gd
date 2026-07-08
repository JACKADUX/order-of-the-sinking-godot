class_name Health extends Component

const K_HEALTH_VALUE := "health_value"
const K_INVINCIBLE := "invincible"

@export var health_value :int= 1
@export var invincible := false

func take_damage(damage:int):
	if invincible or is_dead():
		return 
	health_value = max(0, health_value-abs(damage))
	set_value("health_value", health_value)

func to_death():
	set_value("health_value", 0)
	
func is_dead() -> bool:
	return health_value <= 0

func set_invincible(value:bool):
	set_value("invincible", value)
	
func is_invincible() -> bool:
	return invincible
