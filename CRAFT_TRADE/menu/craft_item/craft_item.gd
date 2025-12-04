class_name CraftItem
extends Button

signal seleccionar_craft_item(craft_item: CraftData)
@export var craft_item: CraftData

@onready var texture = $NinePatchRect/Sprite2D
@onready var nombre_label = $NinePatchRect/NOMBRE
@onready var cantidad_label = $NinePatchRect/CANTIDAD

func _ready() -> void:
	add_to_group("craft_items")
	if not craft_item: return
	texture.texture = craft_item.item.texture
	nombre_label.text = craft_item.item.display_name
	cantidad_label.text = str(craft_item.cantidad)

func _on_pressed() -> void:
	emit_signal("seleccionar_craft_item", craft_item)
