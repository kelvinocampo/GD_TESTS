extends Resource
class_name ItemData 

@export var id_name: String = "nuevo_item"       # ID único para referencia en código
@export var display_name: String = "Nuevo Ítem"   # Nombre visible para el jugador
@export var texture: Texture2D
@export_multiline var description: String = ""   # Descripción del ítem

@export var stackable: bool = true              # ¿Se puede apilar con otros ítems iguales?
@export var max_stack: int = 99                 # Cantidad máxima por slot

enum ItemType { CONSUMABLE, EQUIPMENT, QUEST, RESOURCE }
@export var type: ItemType = ItemType.CONSUMABLE

func use(user: Node) -> void:
	match type:
		ItemType.CONSUMABLE:
			_use_consumable(user)
		ItemType.EQUIPMENT:
			_use_equipment(user)
		_:
			print("El ítem %s no tiene lógica de uso definida." % display_name)

func _use_consumable(_user: Node) -> void:
	print("%s usado. Curando al usuario..." % display_name)

func _use_equipment(_user: Node) -> void:
	print("%s usado. Equipándolo..." % display_name)
