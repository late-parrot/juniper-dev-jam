class_name Player extends RigidBody2D


const FORCE_SCALE = 500.0
const JUMP_FORCE = 200.0
const LAUNCH_FORCE = 500.0
const FLOOR_THRESHOLD = 0.5

var on_floor = false
var reset = false
var stuck = false
var can_launch = false
var jump_sound_cooldown = false
var old_shapes = []
var launch_direction = Vector2.ZERO

@export var disabled = false

@onready var main = $".."

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if disabled:
		return
	
	var d = Input.get_vector("left", "right", "up", "down").normalized()
	if d != Vector2.ZERO:
		launch_direction = d
	%Arrow.rotation = lerp_angle(%Arrow.rotation, launch_direction.angle()-rotation, 0.5)
	
	if reset:
		state.linear_velocity = Vector2.ZERO
		state.angular_velocity = 0
		reset = false
	if stuck:
		sleeping = true
		%Arrow.visible = true
		snap_to_sticky()
		if launch_direction != Vector2.ZERO and can_launch and Input.is_action_just_pressed("launch"):
			state.apply_impulse(launch_direction*LAUNCH_FORCE)
			%Arrow.visible = false
			stuck = false
			%Jump.play()
		return
	
	on_floor = false
	var i = 0
	while i < state.get_contact_count():
		var normal = state.get_contact_local_normal(i)
		var this_contact_on_floor = normal.dot(Vector2.UP) > FLOOR_THRESHOLD
		on_floor = on_floor or this_contact_on_floor
		i += 1
	
	var direction = Input.get_axis("left", "right")
	state.apply_force(Vector2(direction*FORCE_SCALE, 0))
	
	if on_floor and Input.is_action_pressed("jump"):
		linear_velocity.y = -JUMP_FORCE
		#if not jump_sound_cooldown:
		%Jump.play()
			#jump_sound_cooldown = true
			#await get_tree().create_timer(0.1).timeout
			#jump_sound_cooldown = false
		old_shapes.clear()

func _on_hurt_box_body_entered(_body: Node2D) -> void:
	var level = main.get_node("Level")
	position = level.get_node("StartPos").position
	$Camera2D.reset_smoothing()
	reset = true
	level.reset()
	%Death.play()

func _on_goal_box_body_entered(_body: Node2D) -> void:
	await get_tree().create_timer(0.5).timeout
	if not %GoalBox.get_overlapping_bodies().is_empty():
		main.next_level()

func cell_distance(cell) -> float:
	var map = main.get_node("Level/TileMapLayer")
	var global = map.to_global(map.map_to_local(cell))
	return global.distance_to(global_position)

func snap_to_sticky() -> void:
	var map = main.get_node("Level/TileMapLayer")
	var cells = map.get_used_cells_by_id(0, Vector2i(0, 1))
	cells.sort_custom(func(x,y): return cell_distance(x) < cell_distance(y))
	global_position = map.to_global(map.map_to_local(cells[0]))
	#reset = true

func _on_sticky_box_body_entered(_body: Node2D) -> void:
	snap_to_sticky()
	stuck = true
	can_launch = false
	await get_tree().create_timer(0.2).timeout
	can_launch = true

func _on_body_shape_entered(body_rid: RID, _body: Node, body_shape_index: int, _local_shape_index: int) -> void:
	var shape = {"body_rid": body_rid, "shape_index": body_shape_index}
	if shape not in old_shapes:
		%Land.play()
	old_shapes.append(shape)
	await get_tree().create_timer(1).timeout
	old_shapes.erase(shape)
