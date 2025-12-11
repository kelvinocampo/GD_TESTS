extends Camera2D

const VERTICAL_OFFSET: float = -100.0

func _process(delta: float) -> void:
	var target_position: Vector2 = $"../PLAYER".position
	target_position.y += VERTICAL_OFFSET
	position = position.lerp(target_position, delta * 5.0)
