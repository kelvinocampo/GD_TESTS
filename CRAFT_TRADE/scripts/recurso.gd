class_name Recurso
extends Area2D

signal recurso_recolectado(nombre_recurso: String, cantidad: int)

@export var NOMBRE_RECURSO = "recurso"
@export var CANTIDAD_RECURSO = 1
@export var RECOGIDAS_MAX = 5

var cantidad_recolectada = 0

var jugador_en_rango: bool = false

func _ready() -> void:
	var jugadores = get_tree().get_nodes_in_group("jugador")
	if jugadores.size() > 0:
		var player_node = jugadores[0]
		self.connect("recurso_recolectado", player_node._on_recurso_recolectado)

	$DeteccionJugador.body_entered.connect(_on_deteccion_jugador_body_entered)
	$DeteccionJugador.body_exited.connect(_on_deteccion_jugador_body_exited)

# ----------------- DETECCIÓN DE RANGO (Proximidad) -----------------

func _on_deteccion_jugador_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		jugador_en_rango = true

func _on_deteccion_jugador_body_exited(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		jugador_en_rango = false

# ----------------- MANEJO DE ENTRADA (Clic Directo sobre el Objeto) -----------------
func _input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if not jugador_en_rango:
		return

	if event.is_action_pressed("click_izquierdo"):
		_recolectar_recurso()
		get_viewport().set_input_as_handled()


func _recolectar_recurso() -> void:
	emit_signal("recurso_recolectado", NOMBRE_RECURSO, CANTIDAD_RECURSO)
	cantidad_recolectada += 1
	if RECOGIDAS_MAX == cantidad_recolectada:
		_recurso_agotado()
	
func _recurso_agotado() -> void:
	queue_free()
