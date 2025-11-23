class_name Slime
extends CharacterBody2D

# --- VARIABLES ---
@export var health: int = 30
@export var max_health: int = 30
@export var velocidad_movimiento: float = 50.0
@export var damage: int = 10
@onready var lifebar = $LIFE
@onready var animator = $AnimatedSprite2D
@export var player_node: CharacterBody2D = null

# Nuevo estado para controlar si el slime está dañado y no debe moverse
var is_recovering: bool = false
var is_dead: bool = false

# Cooldown para el daño
var damage_cooldown: float = 0.0
var damage_cooldown_time: float = 0.5  # Medio segundo entre ataques

func _ready() -> void:
	lifebar.init_health(max_health)
	
	# Conectamos la señal de animación en _ready()
	# Esta señal se usará para regresar a "default" después de "hurt"
	animator.animation_finished.connect(_on_animation_finished)
	
	animator.play("default") # Inicia el movimiento o IDLE

# ----------------- LÓGICA DE MOVIMIENTO -----------------
func _physics_process(delta: float) -> void:
	# Actualizar el cooldown del daño
	if damage_cooldown > 0:
		damage_cooldown -= delta
	
	# Si está muerto o recuperándose, no hay movimiento
	if is_dead or is_recovering:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	if player_node != null:
		# 1. Calculate the direction to the player
		var direction: Vector2 = global_position.direction_to(player_node.global_position)
		
		# 2. Update velocity based on direction and speed
		velocity = direction * velocidad_movimiento
		
		# 3. Flip the enemy sprite to face the player
		if velocity.x > 0:
			animator.flip_h = false
		elif velocity.x < 0:
			animator.flip_h = true
	
	# 4. Movimiento y colisión
	move_and_slide()
	
	# 5. Verificar colisiones después de move_and_slide()
	if get_slide_collision_count() > 0:
		_manejar_impacto()

# ----------------- GESTIÓN DE DAÑO Y MUERTE -----------------
func recibir_dano(_damage: int) -> void:
	if is_dead:
		return
		
	health -= _damage
	lifebar.health = health
	
	if health <= 0:
		_iniciar_muerte()
	else:
		# Inicia la animación de daño y el estado de recuperación
		is_recovering = true
		animator.play("hurt")
		# El regreso a "default" se gestiona en _on_animation_finished

func _manejar_impacto():
	# Solo hacer daño si el cooldown ha terminado
	if damage_cooldown > 0:
		return
	
	# Iterar sobre todas las colisiones
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var cuerpo_colisionado = collision.get_collider()
		
		if cuerpo_colisionado != null and cuerpo_colisionado.has_method("recibir_dano"):
			cuerpo_colisionado.recibir_dano(damage)
			# Activar el cooldown después de hacer daño
			damage_cooldown = damage_cooldown_time
			break  # Solo hacer daño una vez por ciclo de cooldown

func _iniciar_muerte():
	is_dead = true
	# Detener el movimiento inmediatamente
	velocity = Vector2.ZERO
	$CollisionShape2D.disabled = true
	set_physics_process(false) 
	# Reproducir animación de muerte. La eliminación se llama cuando termina.
	animator.play("death")

func _morir():
	# Función llamada por la señal 'animation_finished' de "death"
	queue_free()

# ----------------- GESTIÓN DE ANIMACIONES -----------------
func _on_animation_finished() -> void:
	# 1. Manejo de Muerte
	if animator.animation == "death":
		_morir()
		return
		
	# 2. Manejo de Recuperación (Después de "hurt")
	if animator.animation == "hurt":
		# Finaliza el estado de recuperación y regresa a la animación de movimiento
		is_recovering = false
		animator.play("default")
