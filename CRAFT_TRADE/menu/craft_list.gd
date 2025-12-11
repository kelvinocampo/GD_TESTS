extends VBoxContainer

@onready var craft_item_escene = preload("res://menu/craft_item/craft_item.tscn")

@export var filtro = ""

const RUTA_CRAFT_ITEMS = "res://recursos/craft/"
var craft_items: Array[CraftData] = []

func _ready() -> void:
	limpiar()
	cargar_crafteos()
	crear_crafteos()

func cargar_crafteos():
	var dir = DirAccess.open(RUTA_CRAFT_ITEMS)
	if dir:
		dir.list_dir_begin()
		var nombre_archivo = dir.get_next()
		while nombre_archivo != "":
			if not dir.current_is_dir() and not nombre_archivo.begins_with("."):
				var ruta_completa = RUTA_CRAFT_ITEMS.path_join(nombre_archivo)
				var craft_item = load(ruta_completa)
				craft_items.append(craft_item)
			nombre_archivo = dir.get_next()
		dir.list_dir_end()
	else:
		print("Error: No se pudo abrir el directorio de crafteos")

func crear_crafteos():
	for craft_item in craft_items:
		var nombre_item: String = craft_item.item.display_name
		if filtro.is_empty() or nombre_item.findn(filtro) != -1:
			var item_visual: CraftItem = craft_item_escene.instantiate()
			item_visual.craft_item = craft_item.duplicate(true)
			add_child(item_visual)

func update(nuevo_filtro: String):
	limpiar()
	filtro = nuevo_filtro
	crear_crafteos()

func limpiar():
	for hijo in get_children():
		hijo.queue_free()
