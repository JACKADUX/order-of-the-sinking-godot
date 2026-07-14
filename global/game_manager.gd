extends Node

var game_data:= {
	"world_datas":{},
	"last_world":""
}

var data_path := "user://data.json"

var application:WorldApplication
var MAIN_WORLD := "res://worlds/world01/world01.tscn"

var main_menu :Node

func _ready() -> void:
	InputMapUtils.action_add_event_key(Const.IM_MAIN_MENU, KEY_ESCAPE)

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST \
		or what == NOTIFICATION_WM_GO_BACK_REQUEST:
		quit()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(Const.IM_MAIN_MENU):
		toggle_main_menu()
		
func toggle_main_menu():
	if not application:
		return 
	if main_menu:
		main_menu.get_parent().queue_free()
		main_menu = null
		application.input_manager.enable = true
		return 
	application.input_manager.enable = false
	var canvas_layer = CanvasLayer.new()
	get_tree().root.add_child(canvas_layer)
	main_menu = preload("uid://bphjjrjos5oga").instantiate()
	canvas_layer.add_child(main_menu)
	main_menu.open_from_world(application.is_level)
	main_menu.close_requested.connect(toggle_main_menu)

func start_world():
	enter_world(load(MAIN_WORLD))

func continue_game():
	if not has_valid_player_data():
		return 
	load_game()
	continue_world(game_data["last_world"])

func save_game():
	if not application:
		return 
	var scene_path = application.owner.scene_file_path
	if scene_path != MAIN_WORLD and not application.is_level:
		return 
	game_data["world_datas"][scene_path] = application.get_data()
	game_data["last_world"] = scene_path
	JsonUtils.save_meta_native(data_path, game_data)
	
func load_game():
	if not FileAccess.file_exists(data_path):
		JsonUtils.save_meta_native(data_path, game_data)
	game_data = JsonUtils.load_meta_native(data_path)

func has_valid_player_data() ->bool:
	return FileAccess.file_exists(data_path)

func enter_world(world:PackedScene, is_level:=false):
	save_game()
	get_tree().change_scene_to_packed(world)
	await get_tree().scene_changed
	application = find_world_application(get_tree().current_scene)
	application.is_level = is_level

func continue_world(scene_path:String):
	var world = load(scene_path)
	await enter_world(world)
	await application.system_initialize
	application.apply_data(game_data["world_datas"].get(scene_path, {}))
	

func exit_level(scene_path:String, finished:bool):
	await continue_world(MAIN_WORLD)
	if finished:
		application.level_manager.set_level_finished(scene_path, finished)
		application.mechanism_service.update()
		application.handle_event(Events.DataChangedEvent.new())
	

func find_world_application(scene:Node) -> WorldApplication:
	for node in scene.find_children("*"):
		if node is WorldApplication:
			return node
	return null

func quit():
	save_game()
	get_tree().quit()
