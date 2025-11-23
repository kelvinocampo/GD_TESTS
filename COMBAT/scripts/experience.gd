class_name OrbeXP
extends Area2D

# --- VARIABLES DE CONFIGURACIÓN ---
@export var valor_xp: int = 10         # Cantidad de experiencia que otorga
@export var velocidad_inicial: float = 150.0 # Velocidad de movimiento inicial
@export var velocidad_aceleracion: float = 800.0 # Aceleración hacia el jugador
@export var rango_deteccion: float = 100.0 # Distancia para iniciar la persecución

var jugador: Node2D = null           # Referencia al jugador
var velocidad_actual: Vector2 = Vector2.ZERO # Velocidad actual del orbe
var en_rango: bool = false           # Bandera para iniciar la persecución

# ----------------- INICIALIZACIÓN Y DETECCIÓN -----------------

func _ready() -> void:
	# 1. Conecta la señal del Area2D para cuando el jugador lo toque.
	body_entered.connect(_on_body_entered)
	
	# Opcional: Dale una dirección inicial aleatoria (si lo deseas)
	# velocidad_actual = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized() * velocidad_inicial

func _physics_process(delta: float) -> void:
	# 1. Buscar al jugador si aún no lo tiene y está cerca
	if jugador == null:
		_buscar_jugador()
		
	# 2. Lógica de persecución y movimiento
	if en_rango and jugador != null:
		_mover_hacia_jugador(delta)
	elif velocidad_actual.length() > 0:
		# Si no está en rango, aplica fricción para detener el movimiento inicial
		velocidad_actual = velocidad_actual.move_toward(Vector2.ZERO, 10 * delta)
		global_position += velocidad_actual * delta

# ----------------- MOVIMIENTO DIRIGIDO -----------------

func _buscar_jugador() -> void:
	# Comprobar la distancia al centro de la escena para ver si el jugador está cerca
	# Esto es mejor si tienes una referencia al nodo del jugador al inicio del juego.
	
	# METODO SIMPLE: Buscar por grupos (asume que el jugador está en el grupo "player")
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		jugador = players[0]

func _mover_hacia_jugador(delta: float) -> void:
	if jugador == null:
		return
		
	# 1. Calcula la dirección al jugador
	var direccion_al_jugador: Vector2 = global_position.direction_to(jugador.global_position)
	
	# 2. Acelera la velocidad actual hacia esa dirección
	velocidad_actual += direccion_al_jugador * velocidad_aceleracion * delta
	
	# 3. Limita la velocidad máxima (opcional)
	velocidad_actual = velocidad_actual.limit_length(500.0)
	
	# 4. Aplica el movimiento
	global_position += velocidad_actual * delta
	
	# Opcional: Si el orbe está muy cerca, teletransportarlo para asegurar la recolección
	if global_position.distance_to(jugador.global_position) < 5:
		_recolectar()

# ----------------- RECOLECCIÓN Y DESTRUCCIÓN -----------------

# Función que se ejecuta cuando el Area2D detecta un cuerpo (solo el jugador)
func _on_body_entered(body: Node2D) -> void:
	# Verificamos que sea el jugador (o la entidad que recolecta)
	if body is CharacterBody2D and body.is_in_group("player"): 
		_recolectar()

func _recolectar() -> void:
	# 1. Otorgar la experiencia (Lógica en el jugador)
	if jugador != null and jugador.has_method("ganar_experiencia"):
		jugador.ganar_experiencia(valor_xp)
	
	# 2. Eliminar el orbe de la escena
	queue_free()

# ----------------- HABILITADOR DE PERSECUCIÓN (Rango) -----------------
# Llamar a esta función constantemente (ej. desde un Area2D padre o en _physics_process)

func _activar_persecucion() -> void:
	# Si el jugador está dentro del rango de detección, activar la persecución
	if jugador != null and global_position.distance_to(jugador.global_position) < rango_deteccion:
		en_rango = true
