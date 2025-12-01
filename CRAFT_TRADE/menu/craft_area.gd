class_name CraftArea
extends VBoxContainer

@export var craft_item: CraftData

@onready var texture = $ICON
@onready var nombre = $NOMBRE
@onready var cantidad = $CANTIDAD

@onready var items_needed: ItemsNeeded = $ITEMS_NEEDED

var player_node: Jugador = null

func _ready():
	var nodos_emisores = get_tree().get_nodes_in_group("craft_items")
	
	for nodo in nodos_emisores:
		if nodo.has_signal("seleccionar_craft_item"):
			nodo.seleccionar_craft_item.connect(_on_craft_item_seleccionado)
	
	var jugadores = get_tree().get_nodes_in_group("jugador")
	if jugadores.size() > 0:
		player_node = jugadores[0]

func _on_craft_item_seleccionado(craft_data: CraftData):
	texture.texture = craft_data.item.texture
	nombre.text = craft_data.item.display_name
	cantidad.text = str(craft_data.cantidad)
	items_needed.update(craft_data.needed_items)
	craft_item = craft_data

func reset():
	pass

func verify_needed_items():
	for item in craft_item.needed_items:
		var cantidad_actual = player_node.inventario.conseguir_cantidad(item.item)
		if cantidad_actual < item.cantidad: return false
	return true

func remover_items():
	for item in craft_item.needed_items:
		player_node.inventario.remover(item.item, item.cantidad)

func _on_craft_pressed() -> void:
	if not craft_item: return
	if not verify_needed_items(): return
	remover_items()
	player_node.inventario.agregar(craft_item.item, craft_item.cantidad)
