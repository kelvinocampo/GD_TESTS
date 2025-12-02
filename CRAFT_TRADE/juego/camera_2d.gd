extends Camera2D

func _process(delta: float) -> void:
	position = position.lerp($"../PLAYER".position, delta * 5)
