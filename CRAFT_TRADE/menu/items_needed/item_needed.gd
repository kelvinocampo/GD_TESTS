class_name ItemNeeded
extends HBoxContainer

@onready var nombre = $NOMBRE
@onready var cantidad = $CANTIDAD

func update(_nombre: String, _cantidad: int):
	nombre.text = str(_nombre)
	cantidad.text = str(_cantidad)
