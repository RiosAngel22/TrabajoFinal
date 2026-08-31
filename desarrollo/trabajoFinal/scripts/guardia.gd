extends CharacterBody2D


@export var velocidad = 300.0


@export var Puntos : Array[Marker2D]

@onready var Detector : detector = $detector
@onready var Raycast : RayCast2D = $detector/RayCast2D

@onready var Icono : icono = $icono
@onready var guardia : Sprite2D = $Imagen

var ObjetivoActual : Marker2D
var PuntoActual : int

var jugadorEncontrado : jugador

var TweenIcono

func _ready() -> void:
	#seteamos la siguiente posicion del guardia
	ObjetivoActual = Puntos[0]
	PuntoActual = 0
	Detector.Detectado.connect(_on_detector_detectado)
	guardia.material.set_shader_parameter("color", Color.TRANSPARENT)
	Icono.ocultar()

func _physics_process(delta: float) -> void:
	
	#si ve al jugador lo sigue, sino, camina normal
	if jugadorEncontrado:
		seguir(delta)
	else:
		merodear(delta)
	
	move_and_slide()
	


func _on_detector_detectado(jugador : CharacterBody2D) -> void:
	#el guardia ve al jugador
	jugadorEncontrado = jugador

func merodear(delta:float)->void:
	#funcion para seguir una ruta
	var direccion : Vector2
	
	#mira y sigue un objetivo
	direccion = (ObjetivoActual.global_position - global_position).normalized()
	velocity = direccion * (velocidad * 2 * delta)
	look_at(ObjetivoActual.global_position)
	global_rotation = global_rotation + (PI/180*90)
	
	#busca el siguiente objetivo
	if global_position.distance_to(ObjetivoActual.global_position) < 5:
		PuntoActual+=1
		if PuntoActual >= Puntos.size():
			PuntoActual = 0
		
		ObjetivoActual = Puntos[PuntoActual]
	
func seguir(delta:float)->void:
	var direccion : Vector2
	
	#mira y sigue al jugador
	direccion = (jugadorEncontrado.global_position - global_position).normalized()
	velocity = direccion * (velocidad * 3 * delta)
	look_at(jugadorEncontrado.global_position)
	global_rotation = global_rotation + (PI/180*90)
	
	if jugadorEncontrado.global_position.distance_to(global_position) <= 30 and Raycast.is_colliding():
		$AnimationPlayer.play("Ataque")


func _on_hit_box_body_entered(body: Node2D) -> void:
	#jugador en rango de ataque
	if body.is_in_group("jugador"):
		body.die()

	
func _on_hurt_box_body_entered(body: Node2D) -> void:
	#el guardia tiene al jugador detras
	if body.is_in_group("jugador"):
		guardia.material.set_shader_parameter("color", Color.RED)
		Icono.mostrar()

func _on_hurt_box_body_exited(body: Node2D) -> void:
	#el guardia se alejo del jugador
	if body.is_in_group("jugador"):
		guardia.material.set_shader_parameter("color", Color.TRANSPARENT)
		Icono.ocultar()

func die():
	queue_free()
