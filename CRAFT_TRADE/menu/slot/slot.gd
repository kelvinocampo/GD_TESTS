extends Control
class_name Slot

@onready var item_visual: Sprite2D = $CenterContainer/Panel/visor
@onready var label_cantidad: Label = $CenterContainer/Panel/Label

func update(slot: SlotData):
	if not slot.item:
		label_cantidad.text = ""
		item_visual.visible = false
	else:
		if slot.cantidad:
			label_cantidad.text = str(slot.cantidad)
		item_visual.visible = true
		item_visual.texture = slot.item.texture
		
