class_name DialogContainer extends PanelContainer

@onready var texture_rect: TextureRect = %TextureRect
@onready var rich_text_label: RichTextLabel = %RichTextLabel

@export var speed :float = 20

func _ready() -> void:
	pass
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		play()

func set_text(text:String):
	rich_text_label.text = text
	
func set_icon(icon:Texture2D):
	texture_rect.texture = icon

func play():
	var duration = rich_text_label.text.length()/speed
	var tween = create_tween()
	tween.tween_property(rich_text_label, "visible_ratio", 1.0, duration).from(0.0)
