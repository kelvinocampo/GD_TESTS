extends CanvasLayer

@export var inventario: InventarioData
@onready var slots: Array = $ColorRect/UI_INVENTARIO/GridContainer.get_children()

@onready var toggle_inventario = $ColorRect/INVENTORY_TOGGLE/AnimatedSprite2D
@onready var toggle_craft = $ColorRect/CRAFT_TOGGLE/AnimatedSprite2D
@onready var toggle_map = $ColorRect/MAP_TOGGLE/AnimatedSprite2D

@onready var inventario_ui = $ColorRect/UI_INVENTARIO
var abierto = false
var menu = ""

func _ready():
	inventario.update.connect(update_slots)
	update_slots()
	cerrar()

func update_slots():
	for i in range(min(inventario.items.size(), slots.size())):
		slots[i].update(inventario.items[i])

func _process(_delta: float) -> void:
	inventario_control()

func inventario_control():
	control_menu("inventario")
	control_menu("craft")
	control_menu("mapa")

	if menu == "":
		cerrar()

func control_menu(accion):
	if Input.is_action_just_pressed(accion) and menu != accion:
		menu = accion
		update_UI()
		abrir()
		return
	elif Input.is_action_just_pressed(accion) and menu == accion:
		menu = ""

func abrir():
	visible = true
	abierto = true

func cerrar():
	visible = false
	abierto = false

func update_UI():
	inventario_ui.visible = false
	toggle_inventario.play("default")
	toggle_craft.play("default")
	toggle_map.play("default")
	if menu == "inventario":
		inventario_ui.visible = true
		toggle_inventario.play("open")
	elif menu == "craft":
		toggle_craft.play("open")
	elif menu == "mapa":
		toggle_map.play("open")

func _on_toggle_inv_pressed() -> void:
	if Input.is_action_just_pressed("inventario"):
		if abierto:
			cerrar()
		else:
			abrir()
