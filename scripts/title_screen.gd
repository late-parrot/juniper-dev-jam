extends Control


var credits = false

var controller: bool = false:
	set(v):
		if v:
			if get_viewport().gui_get_focus_owner() == null:
				if credits:
					%Credits/%Back.grab_focus()
				else:
					%Play.grab_focus()
		else:
			var focused := get_viewport().gui_get_focus_owner()
			if focused:
				focused.release_focus()

func _input(event: InputEvent) -> void:
	if event is InputEventJoypadButton and event.pressed:
		controller = true
	elif event is InputEventJoypadMotion and abs(event.axis_value) > 0.5:
		controller = true

	elif event is InputEventMouseMotion:
		controller = false
	elif event is InputEventMouseButton and event.pressed:
		controller = false

func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_quit_pressed():
	get_tree().quit()

func _on_credits_pressed() -> void:
	if controller:
		%Credits/%Back.grab_focus()
	%Buttons.visible = false
	%Credits.visible = true
	credits = true

func _on_back_pressed() -> void:
	if controller:
		%Start.grab_focus()
	%Credits.visible = false
	%Buttons.visible = true
	credits = false
