class_name Player
extends CharacterBody2D

@export var VELOCIDAD_NORMAL = 300.0
@export var MULTIPLICADOR_CORRER = 2.0
@export var SALTO = -400.0
@export var inventario: InventarioData

@onready var animacion = $AnimatedSprite2D
@onready var song_timer = $song
@onready var chop = $chop
@onready var mine = $mine

var ultima_dir := "derecha"
var interactuando = false

func _ready():
	animacion.animation_finished.connect(_finalizar_animacion)
	add_to_group("jugador")

func _finalizar_animacion():
	if animacion.animation == "jump":
		animacion.play("fall")
		return
	if animacion.animation == "mine" or animacion.animation == "chop":
		if animacion.animation == "chop": chop.stop()
		interactuando = false

func _on_recurso_recolectado(item, cantidad, accion):
	if not is_on_floor() or interactuando: return false
	inventario.agregar(item, cantidad)
	animacion.play(accion)
	if accion == "chop": chop.play()
	if accion == "mine": 
		song_timer.timeout.connect(func(): mine.play())
		song_timer.wait_time = 0.7
		song_timer.start()
	interactuando = true
	return true

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
	if Input.is_action_just_pressed("arriba") and is_on_floor() and not interactuando:
		animacion.play("jump")
		velocity.y = SALTO
	
	# Transición a la animación de Caída
	if not is_on_floor() and velocity.y > 0 and animacion.animation != "fall" and not interactuando:
		animacion.play("fall")

	# Movimiento Lateral
	var direccion := Input.get_axis("izquierda", "derecha")
	
	if direccion != 0 and not interactuando:
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
	if is_on_floor() and animacion.animation != "jump" and not interactuando: 
		
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
