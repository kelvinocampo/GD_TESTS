class_name ArbolT1
extends CharacterBody2D

@export var item: ItemData
@export var CANTIDAD_RECURSO = 1
@export var RECOGIDAS_MAX = 5
@export var TIEMPO_REGENERACION = 10
@export var accion: String
@export var nivel: int = 0

@onready var animacion = $AnimatedSprite2D
@onready var timer = $RESPAWN

var cantidad_recolectada = 0
var player_node: Node = null
var jugador_en_rango: bool = false

func _ready() -> void:
	timer.timeout.connect(respawn)
	timer.wait_time = TIEMPO_REGENERACION
	animacion.play("default")
	var jugadores = get_tree().get_nodes_in_group("jugador")
	if jugadores.size() > 0:
		player_node = jugadores[0]

	$DeteccionJugador.body_entered.connect(_on_deteccion_jugador_body_entered)
	$DeteccionJugador.body_exited.connect(_on_deteccion_jugador_body_exited)

func _process(_delta: float) -> void:
	collect()

# ----------------- DETECCIÓN DE RANGO (Proximidad) -----------------
func _on_deteccion_jugador_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		jugador_en_rango = true

func _on_deteccion_jugador_body_exited(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		jugador_en_rango = false

func _recolectar_recurso() -> void:
	cantidad_recolectada += 1
	if RECOGIDAS_MAX == cantidad_recolectada:
		_recurso_agotado()
	
func _recurso_agotado() -> void:
	set_collision_layer_value(2, false)
	set_collision_mask_value(3, false)
	animacion.play("empty")
	timer.start()

func respawn():
	set_collision_layer_value(2, true)
	set_collision_mask_value(3, true)
	animacion.play("default")
	cantidad_recolectada = 0

func collect() -> void:
	if not jugador_en_rango: return
	
	if Input.is_action_pressed("interactuar"):
		if cantidad_recolectada == RECOGIDAS_MAX: return
		if player_node.nivel[accion] < nivel: return
		var exito = player_node._on_recurso_recolectado(item, CANTIDAD_RECURSO, accion)
		if not exito: return
		_recolectar_recurso()
