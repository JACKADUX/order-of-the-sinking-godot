class_name SimpleTimer

var _timer := 0
func clear():
	_timer = 0

func check_timeout(timeout:float=1) -> bool:
	var current_time = Engine.get_process_frames()
	var fps = Engine.get_frames_per_second()*timeout
	if current_time-_timer < fps:
		return false
	_timer = current_time
	return true
