class_name HelperNote extends PanelContainer

@onready var key_label: Label = %KeyLabel
@onready var tooltip_label: Label = %TooltipLabel

@export var key:=""
@export var tooltip:=""

func _ready() -> void:
	key_label.text = key
	tooltip_label.text = tooltip
