# Archivo: ItemData.gd
class_name ItemData extends Resource

## Datos básicos del ítem
@export var id_name: String = "nuevo_item"       # ID único para referencia en código
@export var display_name: String = "Nuevo Ítem"   # Nombre visible para el jugador
@export var texture: Texture2D
@export_multiline var description: String = ""   # Descripción del ítem
@export var icon: Texture2D                      # Textura/icono para la interfaz de usuario

## Reglas de apilamiento (Stacking)
@export var stackable: bool = true              # ¿Se puede apilar con otros ítems iguales?
@export var max_stack: int = 99                 # Cantidad máxima por slot

## Tipo de ítem (Útil para la lógica del juego)
enum ItemType { CONSUMABLE, EQUIPMENT, QUEST, RESOURCE }
@export var type: ItemType = ItemType.CONSUMABLE

## Lógica de uso (Se puede personalizar para cada tipo)
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
	# Aquí puedes añadir la lógica específica (ej: user.heal(10))
	# NOTA: La lógica para remover el ítem del inventario se manejaría en PlayerInventory después de llamar a esta función.

func _use_equipment(_user: Node) -> void:
	print("%s usado. Equipándolo..." % display_name)
	# Aquí la lógica para equipar (ej: user.equip(self))
