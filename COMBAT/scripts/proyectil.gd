class_name Proyectil_Fuego
extends CharacterBody2D

# --- VARIABLES DE CONFIGURACIÓN ---
@export var velocidad: float = 800.0 # Velocidad de movimiento
@export var duracion_maxima: float = 3.0 # Duración máxima de viaje (3 segundos)
@export var dano: int = 10 # Daño a aplicar
var direccion: Vector2 = Vector2.ZERO # Se establece al instanciar

# --- Nodos ---
@onready var animador: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer_desaparicion: Timer = $DesaparicionTimer
@onready var collision_shape = $CollisionShape2D

# --- Estado ---
var ya_impacto: bool = false # Bandera para evitar doble manejo de colisión/tiempo

func _ready() -> void:
	# 1. Animación inicial
	animador.play("default")

	# 3. Configura e inicia el temporizador de autodestrucción
	timer_desaparicion.wait_time = duracion_maxima
	timer_desaparicion.timeout.connect(_iniciar_explosion)
	timer_desaparicion.start()

func _physics_process(_delta: float) -> void:
	# Si ya impactó, no se mueve ni choca
	if ya_impacto:
		return
		
	# 4. Movimiento normal
	velocity = direccion * velocidad
	# move_and_slide() retorna TRUE si colisionó
	var colision_ocurrio: bool = move_and_slide()
	
	# 5. Lógica de Colisión (Si golpea algo)
	# Revisa si la colisión ocurrió, sin depender de 'is_on_wall()'
	if colision_ocurrio:
		_manejar_impacto()

# Función unificada para empezar la secuencia de explosión (Llamada por timer o impacto)
func _iniciar_explosion() -> void:
	# ⚠️ REGLA CRÍTICA: Aseguramos que la explosión solo ocurra una vez
	if ya_impacto:
		return
		
	ya_impacto = true
	
	# 1. Detiene el proceso y la detección de colisiones
	timer_desaparicion.stop()
	set_physics_process(false)
	collision_shape.disabled = true
	
	# 2. Reproduce la animación de explosión
	animador.play("explosion")
	animador.animation_finished.connect(_desaparecer)

# Función que aplica el daño al impactar y detona el proyectil
func _manejar_impacto() -> void:
	# Lógica de daño
	var cuerpo_colisionado = get_last_slide_collision().get_collider()
	if cuerpo_colisionado != null and cuerpo_colisionado.has_method("recibir_dano"):
		cuerpo_colisionado.recibir_dano(dano)
		
	# Inicia la secuencia de explosión/desaparición
	_iniciar_explosion()

# Función que se llama cuando termina la animación
func _desaparecer() -> void:
	queue_free()
