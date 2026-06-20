extends Node2D


var level = 0


func _ready() -> void:
	load_level(level)

func load_level(id: int) -> void:
	if not ResourceLoader.exists("res://scenes/levels/"+str(id)+".tscn"):
		win()
		return

	var file = load("res://scenes/levels/"+str(id)+".tscn")
	var node = file.instantiate()
	remove_child(get_node("Level"))
	add_child(node)
	move_child(node, 0)
	%Player.position = node.get_node("StartPos").position
	%Player.reset = true

func next_level() -> void:
	level += 1
	load_level(level)

func win() -> void:
	pass
