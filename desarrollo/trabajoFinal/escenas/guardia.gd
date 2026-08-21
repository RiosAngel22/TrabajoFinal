extends CharacterBody2D


@export var velocidad = 300.0
@export var Detector : detector

var jugadorEncontrado : CharacterBody2D

func _ready() -> void:
	Detector.Detectado.connect(_on_detector_detectado)

func _physics_process(delta: float) -> void:
	if jugadorEncontrado:
		velocity = ((jugadorEncontrado.global_position - global_position) * velocidad) * delta
		global_rotation = lerp(global_rotation,(global_position - jugadorEncontrado.global_position).angle() - 90,1)
	else:
		velocity.x = move_toward(velocity.x, 0, velocidad)
		velocity.y = move_toward(velocity.y, 0, velocidad)

	move_and_slide()


func _on_detector_detectado(jugador : CharacterBody2D) -> void:
	jugadorEncontrado = jugador
