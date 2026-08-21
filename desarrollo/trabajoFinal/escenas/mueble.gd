extends CharacterBody2D

@onready var Icono : Sprite2D = $Icono
var TweenIcono

var controlado : bool = false
var EnRango : bool = false

func _ready() -> void:
	crear_loop_flotar()

func _process(delta: float) -> void:
	if controlado:
		velocity = get_global_mouse_position() - global_position
		move_and_slide()
		
		if Input.is_action_just_pressed("rotar+"):
			global_rotation = lerp(global_rotation,global_rotation + 0.5, 0.5)
		elif Input.is_action_just_pressed("rotar-"):
			global_rotation = lerp(global_rotation,global_rotation - 0.5, 0.5)
		$Icono.global_rotation = 0
	
	if EnRango:
		if Input.is_action_just_pressed("interactuar") and controlado == false:
			controlado = true
		elif Input.is_action_just_pressed("interactuar") and controlado == true:
			controlado = false
	
	if EnRango and !controlado:
		Icono.visible = true
	else:
		Icono.visible = false

func _on_area_telepatia_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		EnRango = true
		
func _on_area_telepatia_body_exited(body: Node2D) -> void:
	EnRango = false
	controlado = false

func crear_loop_flotar():
	if !TweenIcono:
		TweenIcono = create_tween()
		TweenIcono.set_ease(Tween.EASE_IN_OUT)
		TweenIcono.set_trans(Tween.TRANS_CIRC)
		TweenIcono.tween_property(Icono,"scale",Icono.scale*1.1,0.9)
		TweenIcono.tween_property(Icono,"scale",Icono.scale*0.9,0.9)
		TweenIcono.set_loops()
