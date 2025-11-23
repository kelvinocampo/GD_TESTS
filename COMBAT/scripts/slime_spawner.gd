extends Node2D
class_name SlimeSpawner

# --- VARIABLES Y REFERENCIAS ---

# Asegúrate de asignar estas variables en el Inspector de Godot.
@export var slime_scene: PackedScene # La escena PackedScene del Slime (.tscn)
@export var player_node: CharacterBody2D # Referencia al nodo del jugador para que el Slime lo persiga
@export var max_spawn_attempts: int = 20 # Intentos máximos para encontrar un punto libre
@export var environment_layer: int = 1 # Capa donde está el mapa/paredes (Capas de Colisión)

# --- NODOS ---
@onready var spawn_area: Area2D = $SpawnArea 
@onready var spawn_timer: Timer = $SpawnTimer

func _ready() -> void:
	# Llama a la función de aparición cuando el temporizador se agota.
	spawn_timer.timeout.connect(_spawn_slime)
	
	if slime_scene == null:
		push_error("ERROR: Debes asignar la escena 'Slime Scene' en el Inspector.")
		set_process_mode(Node.PROCESS_MODE_DISABLED)
		return

	# IMPORTANTE: Asegúrate de llamar a randomize() en el script principal del juego
	# o si no, usa la función 'seed' para asegurar que la generación sea aleatoria.
	# Ej: randomize() 
	
	# Inicia el proceso de spawneo
	spawn_timer.start()

# ----------------- LÓGICA DE VERIFICACIÓN DE COLISIÓN -----------------

# Verifica si un punto está libre de colisiones en la Capa del Entorno
func _esta_punto_libre(posicion_a_verificar: Vector2) -> bool:
	# Accede al espacio de física del mundo actual
	var espacio_de_fisica = get_world_2d().direct_space_state
	
	# Crea los parámetros de la consulta de punto
	var parametros = PhysicsPointQueryParameters2D.new()
	parametros.position = posicion_a_verificar
	
	# Define la capa que se debe revisar (Capa del Ambiente/Mapa)
	# Usa el operador bitwise shift para seleccionar la capa: (1 << (Capa - 1))
	parametros.collision_mask = 1 << (environment_layer - 1)
	
	# Ejecuta la consulta; devuelve un array. Si está vacío, el punto está libre.
	var resultado = espacio_de_fisica.intersect_point(parametros)
	
	return resultado.is_empty()

# ----------------- LÓGICA DE POSICIONAMIENTO -----------------

# Calcula un punto aleatorio dentro del SpawnArea que esté libre de colisiones.
func _obtener_punto_aleatorio() -> Vector2:
	var intentos = 0
	var shape: Shape2D = spawn_area.get_node("CollisionShape2D").shape
	
	if shape is RectangleShape2D:
		var rect_extents: Vector2 = shape.extents
		
		while intentos < max_spawn_attempts:
			# 1. Calcular punto aleatorio dentro del rectángulo
			var rand_x: float = randf_range(-rect_extents.x, rect_extents.x)
			var rand_y: float = randf_range(-rect_extents.y, rect_extents.y)
			var punto_local: Vector2 = Vector2(rand_x, rand_y)
			
			# 2. Convertir a posición global de la escena
			var posicion_global: Vector2 = spawn_area.global_position + punto_local
			
			# 3. Verificar si el punto está libre
			if _esta_punto_libre(posicion_global):
				return posicion_global # ¡Éxito!
				
			intentos += 1
			
	# Si el bucle falla, retorna el centro del área, lo que puede causar colisión inicial
	if intentos >= max_spawn_attempts:
		print("ADVERTENCIA: Fallo al encontrar un punto de spawn libre. Intentos:", max_spawn_attempts)
		
	return spawn_area.global_position


# ----------------- LÓGICA DE SPAWN -----------------

# Función principal llamada por el Timer
func _spawn_slime() -> void:
	if slime_scene == null:
		return
		
	# 1. Obtener una posición válida y libre
	var posicion_aleatoria: Vector2 = _obtener_punto_aleatorio()

	# 2. Crea una instancia del Slime
	var nuevo_slime: Slime = slime_scene.instantiate()
	
	# 3. Posiciona el Slime
	nuevo_slime.global_position = posicion_aleatoria
	
	# 4. Asigna el Player (para la lógica de persecución)
	if player_node != null:
		nuevo_slime.player_node = player_node
	
	# 5. Añade el Slime a la escena principal
	# (Aparecerá como hijo del padre del Spawner)
	get_parent().add_child(nuevo_slime)
