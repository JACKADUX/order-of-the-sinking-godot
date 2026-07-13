class_name WorldApplication extends Application

@export var active_character_index :int= 1

var undo_service : UndoService
var move_service : MoveService
var battle_service : BattleService
var mechanism_service : MechanismService
var buff_service : BuffService
var action_service : ActionService
var zdepth_service : ZDepthService

var input_manager : InputManager
var tilemap_manager : TileMapManager
var entity_manager : EntityManager
var level_manager : LevelManager

func debug_info():
	DebugLabel.set_value("Character", active_character_index)
	DebugLabel.set_value("history_count", undo_service.get_history_count())

func _ready() -> void:
	if not get_tree().root.is_node_ready():
		await get_tree().root.ready
	init_managers()
	init_services()
	init_system.call_deferred()
	debug_info.call_deferred()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		debug_info.call_deferred()

func init_managers():
	# NOTE: 这样会在一开始有点小消耗，但就是简单粗暴
	for manager in owner.find_children("*"):
		if manager is InputManager:
			input_manager = register_manager(manager)
		elif manager is TileMapManager:
			tilemap_manager = register_manager(manager)
		elif manager is EntityManager:
			entity_manager = register_manager(manager)
		elif manager is LevelManager:
			level_manager = register_manager(manager)
			
	for manager :Manager in managers.values():
		manager.init_manager()
			
func init_services():
	undo_service = register_service(UndoService.new(self))
	move_service = register_service(MoveService.new(self))
	battle_service = register_service(BattleService.new(self))
	mechanism_service = register_service(MechanismService.new(self))
	buff_service = register_service(BuffService.new(self))
	action_service = register_service(ActionService.new(self))
	zdepth_service = register_service(ZDepthService.new(self))

func init_system():
	undo_service.clear()
	entity_manager.propagate_event_to_entity(Events.InitEvent.new())
	entity_manager.update_coords_entity_cache()
	switch_character(entity_manager.get_valid_character_index(active_character_index))
	undo_service.reset()
	handle_event(Events.DataChangedEvent.new())

func handle_event(event:BaseEvent):
	if event is Events.UserInputEvent:
		handle_user_input_event(event.action, event.data)
		return 
	entity_manager.propagate_event_to_entity(event)

func update_services():
	entity_manager.update_coords_entity_cache()
	zdepth_service.update()
	buff_service.update()
	mechanism_service.update()
	battle_service.update()
	
	
## User Inputs ----
func handle_user_input_event(action:String, data:={}):
	match action:
		Const.IM_UNDO:
			undo_service.undo()
		Const.IM_RESET:
			undo_service.reset()
		Const.IM_SWITCH_CHARACTER:
			switch_character(data.get("index", active_character_index))
		Const.IM_MOVE:
			character_movement(data.get("dir", Vector2i.ZERO))
		Const.IM_ACTION:
			apply_action()
		Const.IM_ENTER_LEVEL:
			enter_level()

func switch_character(character_index:int):
	entity_manager.update_coords_entity_cache()
	var indexs = entity_manager.get_valid_character_indexs()
	if character_index == -1:
		var index = indexs.find(active_character_index)
		active_character_index = indexs[wrapi(index+1, 0, indexs.size())]
	elif character_index in indexs:
		active_character_index = character_index
	entity_manager.character_activate(active_character_index)
		
func character_movement(dir:Vector2i):
	_before_data_changed()
	entity_manager.update_coords_entity_cache()
	if dir == Vector2i.ZERO:
		return 
	var characters := entity_manager.get_active_characters()
	if not characters:
		return
	# NOTE : 有点暴力但是简单
	undo_service.warp(func():
		for character in characters:
			move_service.try_move(character, dir)
		update_services()
	)

func apply_action():
	_before_data_changed()
	entity_manager.update_coords_entity_cache()
	undo_service.warp(func():
		action_service.update()
		update_services()
	)
		
func _before_data_changed():
	# NOTE : 给视觉层发送通知, 这是为了
	entity_manager.propagate_event_to_entity(Events.BeforeDataChangedEvent.new())

func enter_level():
	if not level_manager:
		return 
	var characters = entity_manager.get_active_characters()
	if characters.size() != 1:
		print("error: 不应该出现多个角色进入关卡的这种情况")
		return 
	var character = characters[0]
	var level_mark := level_manager.get_level_mark_at(character.get_coords())
	if not level_mark:
		return 
	get_tree().change_scene_to_packed(level_mark.level_scene)
	
