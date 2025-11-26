extends Control

@onready var inventario: Inventory = preload("res://inventory/inventory.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()
var abierto = false

func _ready():
	update_slots()
	cerrar()
	
func update_slots():
	for i in range(min(inventario.items.size(), slots.size())):
		slots[i].update(inventario.items[i])

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("inventario"):
		if abierto:
			cerrar()
		else:
			abrir()

func abrir():
	visible = true
	abierto = true

func cerrar():
	visible = false
	abierto = false
