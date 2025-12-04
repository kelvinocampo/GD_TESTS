extends VBoxContainer

@onready var craft_item_escene = preload("res://menu/craft_item/craft_item.tscn")

const RUTA_CRAFT_ITEMS = "res://recursos/craft/"

func _ready() -> void:
	limpiar()
	crear_crafteos()

func crear_crafteos():
	var dir = DirAccess.open(RUTA_CRAFT_ITEMS)

	if dir:
		dir.list_dir_begin()
		var nombre_archivo = dir.get_next()
		while nombre_archivo != "":
			if not dir.current_is_dir() and not nombre_archivo.begins_with("."):
				var ruta_completa = RUTA_CRAFT_ITEMS.path_join(nombre_archivo)
				var craft_item = load(ruta_completa)
				if craft_item is Resource:
					var item_visual: CraftItem = craft_item_escene.instantiate()
					item_visual.craft_item = craft_item.duplicate(true)
					add_child(item_visual)
			nombre_archivo = dir.get_next()
		dir.list_dir_end()
	else:
		print("Error: No se pudo abrir el directorio de crafteos")

func limpiar():
	for hijo in get_children():
		hijo.queue_free()
