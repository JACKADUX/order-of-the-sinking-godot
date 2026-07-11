class_name EditorQuickPopupHelper extends RefCounted

static func popup_at_mouse(fn:Callable) -> PopupMenu:
	var editor_interface := Engine.get_singleton(&"EditorInterface")
	if not editor_interface:
		return
	# 2. 创建一个弹出菜单
	var popup := PopupMenu.new()
	popup.about_to_popup.connect(func():
		fn.call(popup)
		popup.visibility_changed.connect(func():
			if not popup.visible:
				popup.queue_free()
		)
	)
	editor_interface.get_base_control().add_child(popup)
	var mouse_pos := DisplayServer.mouse_get_position()
	popup.popup(Rect2i(mouse_pos.x, mouse_pos.y, 0, 0))
	return popup
