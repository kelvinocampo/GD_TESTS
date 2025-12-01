class_name ItemsNeeded
extends GridContainer

var item_needed = preload("res://menu/items_needed/item_needed.tscn")

func update(items: Array[SlotData]):
	clear()
	for item in items:
		var nueva: ItemNeeded = item_needed.instantiate()
		add_child(nueva)
		nueva.update(item.item.display_name, item.cantidad)

func clear():
	var children = get_children()
	for child in children:
		child.queue_free()
