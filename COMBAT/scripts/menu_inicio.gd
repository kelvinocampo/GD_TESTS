# Script en MenuInicio.gd
extends Control

func _ready():
	# Conecta la señal del botón "Jugar"
	$Fondo/VBoxContainer/Button.pressed.connect(_on_boton_jugar_pressed)

func _on_boton_jugar_pressed():
	get_tree().change_scene_to_file("res://scenes/game.tscn")
	#get_tree().paused = false
