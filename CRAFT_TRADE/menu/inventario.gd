extends CanvasLayer

@export var inventario: InventarioData
@onready var slots: Array = $ColorRect/UI_INVENTARIO/GridContainer.get_children()
@onready var toggle_inventario = $ColorRect/INVENTORY_TOGGLE/AnimatedSprite2D
@onready var toggle_craft = $ColorRect/CRAFT_TOGGLE/AnimatedSprite2D
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
	if Input.is_action_just_pressed("inventario") and menu != "inventario":
		menu = "inventario"
		update_UI()
		abrir()
		return
	elif Input.is_action_just_pressed("inventario") and menu == "inventario":
		menu = ""
	
	if Input.is_action_just_pressed("craft") and menu != "craft":
		menu = "craft"
		update_UI()
		abrir()
		return
	elif Input.is_action_just_pressed("craft") and menu == "craft":
		menu = ""

	if menu == "":
		cerrar()

func control_menu():
	pass

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
	if menu == "inventario":
		inventario_ui.visible = true
		toggle_inventario.play("open")
	elif menu == "craft":
		toggle_craft.play("open")

func _on_toggle_inv_pressed() -> void:
	if Input.is_action_just_pressed("inventario"):
		if abierto:
			cerrar()
		else:
			abrir()
