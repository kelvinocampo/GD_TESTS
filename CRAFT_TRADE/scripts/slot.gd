extends Control

@onready var item_visual: Sprite2D = $CenterContainer/Panel/visor
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update(item: ItemData):
	if not item:
		item_visual.visible = false
	else:
		item_visual.visible = true
		item_visual.texture = item.texture
		
