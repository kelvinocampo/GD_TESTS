class_name InventarioData
extends Resource

signal update()
@export var items: Array[SlotData]

func agregar(item: ItemData, cantidad_a_agregar: int):
	if item == null or cantidad_a_agregar <= 0:
		return
	var restante = cantidad_a_agregar
	if item.stackable:
		var item_slots = items.filter(func(slot): return slot.item == item)
		for slot in item_slots:
			if restante == 0:
				break # Todo agregado
			var espacio_disponible = item.max_stack - slot.cantidad
			if espacio_disponible > 0:
				var cantidad_a_mover = min(restante, espacio_disponible)
				slot.cantidad += cantidad_a_mover
				restante -= cantidad_a_mover
	while restante > 0:
		var empty_slots = items.filter(
			func(_slot): return _slot.item == null
		)
		if empty_slots.is_empty():
			break
		var slot = empty_slots[0]
		var cantidad_a_mover = min(restante, item.max_stack)
		slot.item = item
		slot.cantidad = cantidad_a_mover
		restante -= cantidad_a_mover
	update.emit()

func conseguir_cantidad(item_data: ItemData) -> int:
	if item_data == null:
		return 0
	
	var cantidad_total = 0
	for slot in items:
		if slot.item == item_data:
			cantidad_total += slot.cantidad
	return cantidad_total

func remover(item: ItemData, cantidad_a_eliminar: int):
	if item == null or cantidad_a_eliminar <= 0:
		return
	var restante = cantidad_a_eliminar
	var item_slots = items.filter(func(slot): return slot.item == item)
	for slot in item_slots:
		if restante == 0:
			break # Todo eliminado
		var espacio_disponible = item.max_stack - slot.cantidad
		if espacio_disponible > 0:
			var cantidad_a_mover = min(restante, espacio_disponible)
			slot.cantidad -= cantidad_a_mover
			restante -= cantidad_a_mover
	update.emit()
