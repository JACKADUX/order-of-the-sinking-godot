extends Control

signal close_requested

@onready var continue_button: Button = %ContinueButton
@onready var start_button: Button = %StartButton
@onready var exit_level_button: Button = %ExitLevelButton
@onready var setting_button: Button = %SettingButton
@onready var quit_button: Button = %QuitButton

var _start_count = 0
func _ready() -> void:
	continue_button.pressed.connect(func():
		GameManager.continue_game()
	)
	
	start_button.pressed.connect(func():
		if GameManager.has_valid_player_data() and _start_count <1:
			_start_count+=1
			start_button.text = "确定开始新游戏吗？会覆盖数据"
			return 
		GameManager.start_world()
	)
	
	quit_button.pressed.connect(func():
		GameManager.quit()
	)
	
	exit_level_button.pressed.connect(func():
		GameManager.exit_level(GameManager.application.owner.scene_file_path, false)
		request_close()
	)
	
	menu_state(0)
	_update()

func request_close():
	close_requested.emit()

func open_from_world(is_level:bool):
	if is_level:
		menu_state(2)
	else:
		menu_state(1)
	
func menu_state(state:int):
	for node in find_children("*"):
		if node is Button:
			node.hide()
	match state:
		0 :
			continue_button.show()
			start_button.show()
			setting_button.show()
			quit_button.show()
		1 :
			setting_button.show()
			quit_button.show()
		2 :
			exit_level_button.show()
			setting_button.show()
			quit_button.show()

func _update():
	continue_button.disabled = not GameManager.has_valid_player_data()
