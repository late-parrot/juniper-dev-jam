extends Node

func _enter_tree() -> void:
	get_tree().node_added.connect(_on_node_added)

func _on_node_added(node: Node) -> void:
	if node is Button:
		node.mouse_entered.connect(%Move.play)
		node.focus_entered.connect(%Move.play)
		node.pressed.connect(%Select.play)
