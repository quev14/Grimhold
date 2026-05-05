extends CollisionPolygon2D

func _setup_player_collision():
	var collision = $CollisionPolygon2D
	if not collision:
		return
	
	var width = 16.0
	var height = 32.0
	var hw = width / 2
	var hh = height / 2
	var top_curve = width * 0.15
	
	collision.polygon = PackedVector2Array([
		Vector2(-hw, -hh + top_curve),
		Vector2(-hw + top_curve, -hh),
		Vector2(hw - top_curve, -hh),
		Vector2(hw, -hh + top_curve),
		Vector2(hw, hh),
		Vector2(-hw, hh),
	])
