extends LineEdit

@onready var craft_lista = $"../../ScrollContainer/CRAFT_LIST"

func _on_text_changed(new_text: String) -> void:
	craft_lista.update(new_text.strip_edges())
