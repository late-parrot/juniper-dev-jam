class_name Level extends Node2D

@onready var main = $".."

func _process(delta: float) -> void:
	rotate(0.2*delta)

func reset():
	rotation = 0
