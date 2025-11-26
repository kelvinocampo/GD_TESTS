class_name Player
extends CharacterBody2D

@export var VELOCIDAD_NORMAL = 300.0
@export var MULTIPLICADOR_CORRER = 2.0
@export var SALTO = -400.0

@onready var animacion = $AnimatedSprite2D

@export var inventario: Inventory
var ultima_dir := "derecha"

func _ready():
	add_to_group("jugador")

func _aplicar_salto_real():
	velocity.y = SALTO

func _on_recurso_recolectado(nombre_recurso: String, cantidad: int):
	pass

func _physics_process(delta: float) -> void:
	var VELOCIDAD = VELOCIDAD_NORMAL
	var corriendo = false

	if Input.is_action_pressed("rapido"):
		VELOCIDAD *= MULTIPLICADOR_CORRER
		corriendo = true

	# Gravedad
	if not is_on_floor():
		velocity += get_gravity() * delta

	# INICIAR LA ANIMACIÓN DE PRE-SALTO
	if Input.is_action_just_pressed("arriba") and is_on_floor() and animacion.animation != "jump":
		animacion.play("jump")
		
		# Aplica la fuerza de salto real SOLO cuando la animación termine, y se desconecta automáticamente.
		animacion.animation_finished.connect(_aplicar_salto_real, CONNECT_ONE_SHOT)
	
	# Transición a la animación de Caída
	if not is_on_floor() and velocity.y > 0 and animacion.animation != "fall":
		animacion.play("fall")

	# Movimiento Lateral
	var direccion := Input.get_axis("izquierda", "derecha")
	
	if direccion != 0:
		velocity.x = direccion * VELOCIDAD

		if direccion > 0:
			ultima_dir = "derecha"
		elif direccion < 0:
			ultima_dir = "izquierda"

		animacion.flip_h = (ultima_dir == "izquierda")

	else:
		# Desaceleración
		velocity.x = move_toward(velocity.x, 0, VELOCIDAD)

	# CONTROL DE ANIMACIÓN EN EL SUELO
	# Solo reproduce IDLE/WALK si está en el suelo Y NO está en la animación de PRE-SALTO.
	if is_on_floor() and animacion.animation != "jump": 
		
		# Ajustar speed_scale
		if corriendo:
			animacion.speed_scale = MULTIPLICADOR_CORRER
		else:
			animacion.speed_scale = 1.0

		if direccion != 0:
			animacion.play("walk")
		else:
			animacion.flip_h = (ultima_dir == "izquierda")
			animacion.play("idle")
		
	# Realizar el movimiento
	move_and_slide()
