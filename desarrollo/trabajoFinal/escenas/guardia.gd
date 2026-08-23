extends CharacterBody2D


@export var velocidad = 300.0
@export var Detector : detector

@export var Puntos : Array[Marker2D]
var ObjetivoActual : Marker2D
var PuntoActual : int

var jugadorEncontrado : CharacterBody2D
var jugadorEnRango : CharacterBody2D

func _ready() -> void:
	ObjetivoActual = Puntos[0]
	PuntoActual = 0
	Detector.Detectado.connect(_on_detector_detectado)

func _physics_process(delta: float) -> void:
	if jugadorEncontrado:
		seguir(delta)
	else:
		merodear(delta)

	move_and_slide()


func _on_detector_detectado(jugador : CharacterBody2D) -> void:
	jugadorEncontrado = jugador

func merodear(delta:float)->void:
	var direccion : Vector2
	
	direccion = (ObjetivoActual.global_position - global_position).normalized()
	
	velocity = direccion * (velocidad * delta)
	look_at(ObjetivoActual.global_position)
	global_rotation = global_rotation + (PI/180*90)
	
	if global_position.distance_to(ObjetivoActual.global_position) < 5:
		PuntoActual+=1
		if PuntoActual >= Puntos.size():
			PuntoActual = 0
		
		ObjetivoActual = Puntos[PuntoActual]
		

func seguir(delta:float)->void:
	var direccion : Vector2
	
	direccion = (jugadorEncontrado.global_position - global_position).normalized()
	
	velocity = direccion * (velocidad * delta)
	look_at(jugadorEncontrado.global_position)
	global_rotation = global_rotation + (PI/180*90)


func _on_hit_box_body_entered(body: Node2D) -> void:
	if body is jugador:
		$Timer.start()
		jugadorEnRango = body

func _on_hit_box_body_exited(body: Node2D) -> void:
	if body is jugador:
		$Timer.stop()
		$Timer.wait_time = 1
		jugadorEnRango = null

func _on_timer_timeout() -> void:
	if jugadorEnRango:
		jugadorEnRango.die()
	
func _on_hurt_box_body_entered(body: Node2D) -> void:
	if body is jugador and Input.is_action_pressed("click"):
		die()
	
func die():
	queue_free()
