class_name Player
extends CharacterBody2D

@export var SPEED := 100
@export var max_health: int = 100
@export var health: int = 100
# Guarda la última dirección: "right", "left", "up", "down"
var last_dir := "right"
var experience = 0

@onready var lifebar = $Camera2D/Control/LIFE
@onready var experiencelabel = $Camera2D/Control/Label


const Proyectil_Escena = preload("res://scenes/proyectil.tscn")

func _physics_process(_delta):
	# Lectura de input (sin normalizar todavía)
	var raw_input = Vector2(
		Input.get_axis("izquierda", "derecha"),
		Input.get_axis("arriba", "abajo")
	)

	if raw_input.length() > 0:
		# Movimiento: normalizamos para evitar mayor velocidad en diagonal
		var input_vector = raw_input.normalized()
		velocity = input_vector * SPEED

		# Determinar y almacenar la última dirección
		# Prioridad vertical: si y != 0 usamos arriba/abajo; si no, horizontal
		if raw_input.y < 0:
			last_dir = "up"
		elif raw_input.y > 0:
			last_dir = "down"
		elif raw_input.x > 0:
			last_dir = "right"
		elif raw_input.x < 0:
			last_dir = "left"

		# Reproducir animación según la dirección actual (movimiento)
		match last_dir:
			"up":
				$AnimatedSprite2D.play("up")
				$AnimatedSprite2D.flip_h = false
			"down":
				$AnimatedSprite2D.play("down")
				$AnimatedSprite2D.flip_h = false
			"left", "right":
				$AnimatedSprite2D.play("run")
				# para movimiento lateral usamos la componente x real para flip,
				# así en diagonales laterales también se refleja correctamente
				$AnimatedSprite2D.flip_h = (raw_input.x < 0)

	else:
		# Sin movimiento → poner idle según la última dirección conocida
		velocity = Vector2.ZERO

		match last_dir:
			"up":
				$AnimatedSprite2D.play("up_idle")
				$AnimatedSprite2D.flip_h = false
			"right":
				$AnimatedSprite2D.play("right_idle")
				$AnimatedSprite2D.flip_h = false
			"left":
				# usamos right_idle pero volteado para left_idle
				$AnimatedSprite2D.play("right_idle")
				$AnimatedSprite2D.flip_h = true
			_:
				# fallback seguro
				$AnimatedSprite2D.play("idle")
				$AnimatedSprite2D.flip_h = false

	move_and_slide()

func _ready():
	add_to_group("player")
	lifebar.init_health(max_health)

func die() -> void:
	print("Muerto")

# 1. Carga la escena del proyectil

# 2. Nodo de origen del disparo (Asegúrate de tener un Marker2D llamado 'PuntoDisparo' en el Jugador)
@onready var punto_disparo = $PuntoDisparo 

# 3. Detectar el clic del ratón
func _input(event: InputEvent) -> void:
	# Usamos "click_izquierdo" como ejemplo de acción. 
	# Configura esta acción en Project > Project Settings > Input Map.
	if event.is_action_pressed("click_izquierdo"): 
		_disparar_hacia_mouse()

# 4. Función de disparo
func _disparar_hacia_mouse() -> void:
	# Instancia el proyectil
	var nuevo_proyectil = Proyectil_Escena.instantiate()
	
	# Obtiene el nodo raíz del árbol (o el nodo que contenga ambos, Jugador y Proyectiles)
	get_parent().add_child(nuevo_proyectil)
	
	# 4.1. Establece la posición de origen del disparo
	var origen_disparo = punto_disparo.global_position
	nuevo_proyectil.global_position = origen_disparo
	
	# 4.2. Calcula la dirección: Vector desde el origen hasta la posición del ratón
	var posicion_mouse = get_global_mouse_position()
	# La resta crea un vector, y `normalized()` asegura que su longitud sea 1 (solo dirección)
	var direccion_disparo = (posicion_mouse - origen_disparo).normalized()
	
	## 4.3. Establece la posición de origen y añade un pequeño desplazamiento
	#var desplazamiento: float = 17.0 
	#nuevo_proyectil.global_position = origen_disparo + direccion_disparo * desplazamiento
	
	# 4.3. Asigna la dirección al proyectil
	nuevo_proyectil.direccion = direccion_disparo

	# 4.4. Opcional: Rota el proyectil visualmente para que apunte a la dirección de disparo
	nuevo_proyectil.rotation = direccion_disparo.angle()

func recibir_dano(_damage):
	# Restar el daño primero
	health -= _damage
	lifebar.health = health
	
	# Verificar si el jugador murió
	if health <= 0:
		die()

func ganar_experiencia(xp: int) -> void:
	# Aquí va tu lógica de aumento de XP, nivel, etc.
	print("¡Ganaste ", xp, " de experiencia!")
	experience += xp
	experiencelabel.text = "Experiencia: " + str(experience)
	
