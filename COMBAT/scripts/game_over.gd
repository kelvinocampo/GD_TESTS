# Script en GameOver.gd
extends CanvasLayer

func _on_retry_pressed():
	# 1. CLAVE: Despausar el juego
	get_tree().paused = false 
	
	# 2. Cargar la escena de juego
	get_tree().change_scene_to_file("res://scenes/game.tscn")
	
	queue_free()

func _on_out_pressed():
	# Despausar antes de salir (buena práctica)
	get_tree().paused = false
	get_tree().quit()
