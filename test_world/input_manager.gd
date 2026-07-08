class_name InputManager extends Node

@export var entity_manager:EntityManager
@export var tilemap_manager:TileMapManager

@export var active_character_index :int= 1

var undo_service : UndoService
var move_service : MoveService
var battle_service : BattleService
var mechanism_service : MechanismService
var buff_service : BuffService
var action_service : ActionService

func _ready() -> void:
	InputMapUtils.action_add_event_key(Const.IM_LEFT, KEY_A)
	InputMapUtils.action_add_event_key(Const.IM_RIGHT, KEY_D)
	InputMapUtils.action_add_event_key(Const.IM_UP, KEY_W)
	InputMapUtils.action_add_event_key(Const.IM_DOWN, KEY_S)
	
	InputMapUtils.action_add_event_key(Const.IM_UNDO, KEY_Z)
	InputMapUtils.action_add_event_key(Const.IM_ACTION, KEY_X)
	InputMapUtils.action_add_event_key(Const.IM_SWITCH_CHARACTER, KEY_C)
	InputMapUtils.action_add_event_key(Const.IM_ENTER_LEVEL, KEY_V)
	InputMapUtils.action_add_event_key(Const.IM_RESET, KEY_R)
	
	undo_service = UndoService.new(entity_manager)
	move_service = MoveService.new(tilemap_manager, entity_manager)
	battle_service = BattleService.new(entity_manager) 
	mechanism_service = MechanismService.new(tilemap_manager, entity_manager)
	buff_service = BuffService.new(tilemap_manager, entity_manager)
	action_service = ActionService.new(entity_manager)
	
	
	undo_service.event_rasied.connect(handle_service_event)
	mechanism_service.event_rasied.connect(handle_service_event)
	action_service.event_rasied.connect(handle_service_event)
	
	handle_service_event.call_deferred(Events.DataChangedEvent.new())

	character_activate.call_deferred(active_character_index)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(Const.IM_UNDO):
		undo_service.undo()
	switch_character(event)
	action_check(event)
	character_movement(event)
	#if event.is_action_pressed(Const.IM_ENTER_LEVEL):
		#var level_marker = Const.get_level_marker_at(Const.get_coords(player.global_position))
		#if level_marker and level_marker.activate:
			#get_tree().change_scene_to_packed.call_deferred(level_marker.level)
			#return 
	
	debug_info()

func debug_info():
	DebugLabel.set_value("Character", active_character_index)

func switch_character(event:InputEvent):
	if event.is_action_pressed(Const.IM_SWITCH_CHARACTER):
		var d := {}
		for character:Character in entity_manager.get_characters():
			d[character.get_character_index()] = true
		var indexs = d.keys()
		indexs.sort() 
		var index = indexs.find(active_character_index)
		active_character_index = indexs[wrapi(index+1, 0, indexs.size())]
		character_activate(active_character_index)
		
	if event is InputEventKey and  KEY_1 <= event.keycode and event.keycode <= KEY_0 :
		active_character_index = (event.keycode-KEY_1)+1
		character_activate(active_character_index)
		
func character_activate(index:int):
	for character :Character in entity_manager.get_characters():
		character.active = character.get_component(Ability).type == index

func character_movement(event:InputEvent):
	var dir := Vector2i.ZERO
	if event.is_action_pressed(Const.IM_LEFT):
		dir = Vector2.LEFT
	if event.is_action_pressed(Const.IM_RIGHT):
		dir = Vector2.RIGHT
	if event.is_action_pressed(Const.IM_UP):
		dir = Vector2.UP
	if event.is_action_pressed(Const.IM_DOWN):
		dir = Vector2.DOWN
	if dir != Vector2i.ZERO:
		var characters := entity_manager.get_characters().filter(func(c): return c.is_active())
		if not characters:
			return
		# NOTE : 有点暴力但是简单
		undo_service.warp(func():
			for character in characters:
				move_service.try_move(character, dir)
		)

func action_check(event:InputEvent):
	if event.is_action_pressed(Const.IM_ACTION):
		undo_service.warp(func():
			action_service.update()
		)

# ---
func handle_service_event(event:BaseEvent):
	if event is Events.DataChangedEvent:
		buff_service.update()
		mechanism_service.update()
		battle_service.update()
		get_tree().call_group(Const.GROUP_ENTITY, "handle_event", event)


	
