extends Node

func _ready() -> void:
	test.call_deferred()
func test(count:int=50):
	const ROCK = preload("uid://caklk028v5vpf")
	for x in range(count):
		for y in range(count):
			var rock = ROCK.instantiate()
			get_parent().add_child(rock)
			rock.teleport(Vector2i(x,y+1))
	queue_free()
