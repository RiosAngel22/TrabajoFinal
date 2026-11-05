extends CharacterBody2D


@export var velocidad = 300.0


@export var Puntos : Array[Marker2D]

@onready var Detector : detector = $detector
@onready var Raycast : RayCast2D = $detector/RayCast2D

@onready var Icono : icono = $icono
@onready var guardia : Sprite2D = $Imagen
@onready var timer : Timer = $TimerOlvidar
@onready var navegador : NavigationAgent2D = $NavigationAgent2D


var ObjetivoActual : Marker2D
var PuntoActual : int

var ataco = false

var jugadorEncontrado : jugador

var TweenIcono
var jugadorEnPosicion :bool=false

func _ready() -> void:
	#seteamos la siguiente posicion del guardia
	ObjetivoActual = Puntos[0]
	navegador.target_position = ObjetivoActual.global_position
	PuntoActual = 0
	Detector.Detectado.connect(_on_detector_detectado)
	Detector.Perdido.connect(olvidar)
	guardia.material.set_shader_parameter("color", Color.TRANSPARENT)
	Icono.ocultar()

func _physics_process(delta: float) -> void:
	
	#si ve al jugador lo sigue, sino, camina normal
	if jugadorEncontrado and !ataco:
		seguir(delta)
	elif jugadorEncontrado and ataco:
		alejarse(delta)
	else:
		merodear(delta)
		
	move_and_slide()
	
	if jugadorEncontrado and jugadorEncontrado.escondido == true:
		await get_tree().create_timer(1).timeout
		if jugadorEncontrado and jugadorEncontrado.escondido == false:
			return
		else:
			jugadorEncontrado = null
	
	
	


func _on_detector_detectado(jugador : CharacterBody2D) -> void:
	#el guardia ve al jugador
	jugadorEncontrado = jugador
	timer.stop()

func olvidar():
	if jugadorEncontrado and timer != null:
		timer.start()
		await timer.timeout
		jugadorEncontrado = null

func merodear(delta:float)->void:
	#funcion para seguir una ruta
	var direccion : Vector2
	
	#mira y sigue un objetivo
	navegador.target_position = ObjetivoActual.global_position
	direccion = (navegador.get_next_path_position() - global_position).normalized()
	velocity = direccion * (velocidad * 2 * delta)
	look_at(navegador.get_next_path_position())
	global_rotation = global_rotation + (PI/180*90)
	
	#busca el siguiente objetivo
	if global_position.distance_to(ObjetivoActual.global_position) < 5:
		PuntoActual+=1
		if PuntoActual >= Puntos.size():
			PuntoActual = 0
		
		ObjetivoActual = Puntos[PuntoActual]
		navegador.target_position = ObjetivoActual.global_position

	
func seguir(delta:float)->void:
	var direccion : Vector2
	
	#mira y sigue al jugador
	
	navegador.target_position = jugadorEncontrado.global_position
	direccion = (navegador.get_next_path_position() - global_position).normalized()
	velocity = direccion * (velocidad * 3 * delta)
	look_at(navegador.get_next_path_position())
	global_rotation = global_rotation + (PI/180*90)
	
	if jugadorEncontrado.global_position.distance_to(global_position) <= 40 and Raycast.is_colliding():
		$AnimationPlayer.play("Ataque")
		ataco = true

func alejarse(delta: float)->void:
	var direccion : Vector2
	
	#mira y se aleja del jugador
	if jugadorEncontrado:
		direccion = (jugadorEncontrado.global_position + global_position).normalized()
		velocity = direccion * (velocidad * 3 * delta)
		look_at(jugadorEncontrado.global_position)
		global_rotation = global_rotation + (PI/180*90)
	
	await get_tree().create_timer(1).timeout
	ataco = false

func _on_hit_box_body_entered(body: Node2D) -> void:
	#jugador en rango de ataque
	if body.is_in_group("jugador"):
		$AudioStreamPlayer2D.play()
		body.hit(20)
		

	
func _on_hurt_box_body_entered(body: Node2D) -> void:
	#el guardia tiene al jugador detras
	if body.is_in_group("jugador"):
		guardia.material.set_shader_parameter("color", Color.RED)
		Icono.mostrar()
		jugadorEnPosicion = true

func _on_hurt_box_body_exited(body: Node2D) -> void:
	#el guardia se alejo del jugador
	if body.is_in_group("jugador"):
		guardia.material.set_shader_parameter("color", Color.TRANSPARENT)
		Icono.ocultar()
		jugadorEnPosicion = false

func die():
	if jugadorEnPosicion:
		queue_free()
