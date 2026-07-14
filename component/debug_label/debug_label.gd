extends CanvasLayer

@onready var rich_text_label: RichTextLabel = %RichTextLabel

var data := {}

func set_value(key:String, value:Variant):
	if data.get(key) == value:
		return 
	data[key] = value
	update()
	
func update():
	var text = ""
	for key in data:
		text += str(key) +" : "
		text += str(data[key]) + "\n"
	rich_text_label.text = text
