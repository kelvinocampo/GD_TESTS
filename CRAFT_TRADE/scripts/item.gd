class_name Item
extends PanelContainer

@export var quantity: int = 0
@export var sprite_url: String = ""

# Verifica el nombre de tu nodo Label en el editor. ¡DEBE COINCIDIR!
# Si se llama QUANTITY, déjalo así. Si se llama QuantityLabel, usa eso.
@onready var quantity_text: Label = $MarginContainer/CANTIDAD # Asegúrate de que este nombre sea correcto
@onready var sprite: TextureRect = $Container/TextureRect


func _ready() -> void:
	# 1. Cargar el sprite, si la URL es válida
	if sprite_url and sprite_url.length() > 0:
		# Utilizamos is_instance_valid para comprobar que el nodo sprite existe antes de usarlo
		if is_instance_valid(sprite):
			sprite.texture = load(sprite_url)
	
	# 2. Asignar la cantidad de texto
	# ¡Esta es la parte importante! Verifica si el nodo Label se cargó (no es null)
	if is_instance_valid(quantity_text):
		quantity_text.text = str(quantity)
	else:
		# Imprime un mensaje de error claro si el nodo no se encuentra
		print("ERROR: El nodo Label para la cantidad no se encontró. ¿Está bien escrito el nombre '$QUANTITY'?")


func _process(_delta: float) -> void:
	pass
