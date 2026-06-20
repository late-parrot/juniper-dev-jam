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
	$Level.name = "OldLevel"
	add_child(node)
	move_child(node, 0)
	
	%Player.position = node.get_node("StartPos").position
	%Player/Camera2D.reset_smoothing()
	%Player.reset = true
	remove_child($OldLevel)

func next_level() -> void:
	level += 1
	load_level(level)

func win() -> void:
	pass
