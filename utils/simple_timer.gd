class_name SimpleTimer

var _time :float= 0

func clear():
	_time = 0

func check_timeout(delta:float, timeout:float=1) -> bool:
	_time += delta
	if _time >= timeout:
		_time = 0
		return true
	return false
