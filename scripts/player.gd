extends RigidBody2D


const FORCE_SCALE = 500.0
const JUMP_FORCE = 200.0

var on_floor = false

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	on_floor = false
	var i := 0
	while i < state.get_contact_count():
		var normal := state.get_contact_local_normal(i)
		var this_contact_on_floor = normal.dot(Vector2.UP) > 0.8
		on_floor = on_floor or this_contact_on_floor
		i += 1

func _physics_process(_delta: float) -> void:
	var direction = Input.get_axis("left", "right")
	apply_force(Vector2(direction*FORCE_SCALE, 0))
	
	if on_floor and Input.is_action_pressed("jump"):
		linear_velocity.y = -JUMP_FORCE
