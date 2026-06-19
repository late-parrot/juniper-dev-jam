extends Node2D

#func _ready() -> void:
	#$RotationOrigin.position = -$"../Player".position
	#
	#for c in %TileMapLayer.get_used_cells():
		#var quadrant_size = %TileMapLayer.rendering_quadrant_size
		#
		#var data: TileData = %TileMapLayer.get_cell_tile_data(c) 
		#var points: PackedVector2Array = data.get_collision_polygon_points(0, 0) 
		#var collision_shape = CollisionPolygon2D.new()
		#collision_shape.polygon = points
		#var new_pos = Vector2(c)*16+Vector2(8,8) #Vector2i(quadrant_size * 2, (quadrant_size * 2) - 1) + (c * Vector2i(quadrant_size, quadrant_size) * 4)
		#
		#collision_shape.position = new_pos
		#%AnimatableBody2D.add_child(collision_shape)
#
#func _physics_process(delta: float) -> void:
	#$RotationOrigin.position -= $"../Player".velocity * delta
	#$"../Player".position = Vector2.ZERO
	
func _process(delta: float) -> void:
	%TileMapLayer.rotate(0.2*delta)
