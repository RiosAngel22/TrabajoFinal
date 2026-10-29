extends CharacterBody2D

@onready var Icono : icono = $icono
@onready var Objeto : Sprite2D = $Objeto

var TweenIcono

var controlado : bool = false
var EnRango : bool = false


func _process(delta: float) -> void:
	#si es controlado, sigue el mouse
	if controlado:
		velocity = get_global_mouse_position() - global_position
		move_and_slide()
		
		#usamos la rueda del mouse para rotar
		if Input.is_action_just_pressed("rotar+"):
			global_rotation = lerp(global_rotation,global_rotation + 0.5, 0.5)
		elif Input.is_action_just_pressed("rotar-"):
			global_rotation = lerp(global_rotation,global_rotation - 0.5, 0.5)
	
	#si esta en rango, aceptamos el input del jugador
	if EnRango:
		if Input.is_action_just_pressed("interactuar") and controlado == false:
			controlado = true
			$Agarrar.play()
			
		elif Input.is_action_just_pressed("interactuar") and controlado == true:
			controlado = false
			$Soltar.play()
		
	
	#informacion en pantalla sobre rango y posesion del objeto
	if EnRango and !controlado:
		Icono.mostrar()
		Objeto.material.set_shader_parameter("color", Color("00ffff"))

	if EnRango and controlado:
		Icono.ocultar()
		
	if !EnRango:
		Icono.ocultar()
		Objeto.material.set_shader_parameter("color", Color.WHITE)
		

func _on_area_telepatia_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		EnRango = true
		
		
func _on_area_telepatia_body_exited(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		EnRango = false
		controlado = false
