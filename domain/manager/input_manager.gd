class_name InputManager extends Manager

var actions := {
	Const.IM_LEFT: KEY_A,
	Const.IM_RIGHT: KEY_D,
	Const.IM_UP: KEY_W,
	Const.IM_DOWN: KEY_S,
	Const.IM_UNDO: KEY_Z,
	Const.IM_ACTION: KEY_X,
	Const.IM_SWITCH_CHARACTER: KEY_C,
	Const.IM_ENTER_LEVEL: KEY_V,
	Const.IM_RESET: KEY_R,
}

@export var enable := true
@export var ban_reset := false 
@export var input_delay :float = 0.2
 
func _ready() -> void:
	for action in actions:
		InputMapUtils.action_add_event_key(action, actions[action])
	
func raise_user_input_event(action:String, data:={}) :
	raise_event(Events.UserInputEvent.new(action, data))

func _unhandled_input(event: InputEvent) -> void:
	if not enable:
		return 
	if event is not InputEventKey:
		return 
	if ban_reset and event.is_action_pressed(Const.IM_RESET):
		print("禁用reset可以单独发送事件告知玩家")
		return 
	if event.is_action(Const.IM_LEFT) or event.is_action(Const.IM_RIGHT) \
		or event.is_action(Const.IM_UP) or event.is_action(Const.IM_DOWN):
		return 
	if switch_character(event):
		return 
	for action in actions:
		if event.is_action_pressed(action):
			raise_user_input_event(action)

func _process(_delta: float) -> void:
	if not enable:
		return 
	# NOTE: 老实说不太喜欢在 _process 中判定 但是 InputEvent 按压事件的延后太长
	var dir = Input.get_vector(Const.IM_LEFT, Const.IM_RIGHT, Const.IM_UP, Const.IM_DOWN)
	if not dir.is_zero_approx():
		move_event()

var _timer := SimpleTimer.new()
func move_event() -> bool:
	var dir := Vector2i.ZERO
	var _clear := false
	if Input.is_action_just_pressed(Const.IM_LEFT):
		dir = Vector2.LEFT
		_clear = true
	elif Input.is_action_pressed(Const.IM_LEFT):
		dir = Vector2.LEFT
		
	if Input.is_action_just_pressed(Const.IM_RIGHT):
		dir = Vector2.RIGHT
		_clear = true
	elif Input.is_action_pressed(Const.IM_RIGHT):
		dir = Vector2.RIGHT
		
	if Input.is_action_just_pressed(Const.IM_UP):
		dir = Vector2.UP
		_clear = true
	elif Input.is_action_pressed(Const.IM_UP):
		dir = Vector2.UP
		
	if Input.is_action_just_pressed(Const.IM_DOWN):
		dir = Vector2.DOWN
		_clear = true
	elif Input.is_action_pressed(Const.IM_DOWN):
		dir = Vector2.DOWN
	
		
	if dir != Vector2i.ZERO:
		if _clear:
			_timer.clear()
		if _clear or _timer.check_timeout(get_process_delta_time(),input_delay):
			raise_user_input_event(Const.IM_MOVE, {"dir": dir})
		return true
	return false

func switch_character(event:InputEvent) -> bool:
	if event.is_action_pressed(Const.IM_SWITCH_CHARACTER):
		raise_user_input_event(Const.IM_SWITCH_CHARACTER, {"index":-1})
		return true
	if event is InputEventKey and event.is_pressed() and KEY_0 <= event.keycode and event.keycode <= KEY_9 :
		var index = (event.keycode-KEY_1)+1
		raise_user_input_event(Const.IM_SWITCH_CHARACTER, {"index":index})
		return true
	return false







	

	
	
