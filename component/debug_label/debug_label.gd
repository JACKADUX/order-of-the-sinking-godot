extends RichTextLabel

var data := {}

func set_value(key:String, value:Variant):
	if data.get(key) == value:
		return 
	data[key] = value
	update()
	
func update():
	text = ""
	for key in data:
		text += str(key) +" : "
		text += str(data[key]) + "\n"
