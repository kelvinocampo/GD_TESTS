# Script en GameOver.gd
extends CanvasLayer

func _on_out_pressed() -> void:
	# Sale de la aplicación
	get_tree().quit()


func _on_retry_pressed() -> void:
	print('aaaaa')
	# Reinicia la escena actual (Mapa)
	var escena_actual = get_tree().current_scene.get_path()
	get_tree().change_scene_to_file(escena_actual)
	#get_tree().paused = false
