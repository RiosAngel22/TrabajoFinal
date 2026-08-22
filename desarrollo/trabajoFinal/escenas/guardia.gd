extends CharacterBody2D


@export var velocidad = 300.0
@export var Detector : detector

@export var Punto1 : Marker2D
@export var Punto2 : Marker2D

var ObjetivoActual : Marker2D
var ObjetivoSiguiente: Marker2D
var jugadorEncontrado : CharacterBody2D

func _ready() -> void:
	ObjetivoActual = Punto1
	ObjetivoSiguiente = Punto2
	
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
	var ObjetivoAuxiliar
	
	direccion = (ObjetivoActual.global_position - global_position).normalized()
	
	velocity = (direccion * velocidad)
	look_at(ObjetivoActual.global_position)
	global_rotation = global_rotation + (PI/180*90)
	
	
	if global_position.distance_to(ObjetivoActual.global_position) < 5:
		ObjetivoAuxiliar = ObjetivoActual
		ObjetivoActual = ObjetivoSiguiente
		ObjetivoSiguiente = ObjetivoAuxiliar
	

func seguir(delta:float)->void:
	velocity = ((jugadorEncontrado.global_position - global_position) * velocidad) * delta
	look_at(jugadorEncontrado.global_position)
	global_rotation = global_rotation + (PI/180*90)
