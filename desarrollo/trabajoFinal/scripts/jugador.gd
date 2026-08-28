extends CharacterBody2D
class_name jugador

@onready var sprite : Sprite2D = $Sprite2D
@onready var guia : Polygon2D = $Polygon2D

@onready var raycast : RayCast2D = $Sprite2D/RayCast2D
@export var velocidad = 5000.0

@onready var CoolDownSombra : TextureProgressBar = $CanvasLayer/TextureProgressBar
@export var CoolDownRate : float = 0.1
@export var CantidadDeSangreAbsorvida : float = 30

var rotacionActual : float = 0
var tweenflotacion : Tween

var puedeAtacar := false

var sombra := false
var escondido := false

func _ready() -> void:
	crear_loop_flotar()
	CoolDownSombra.value = 0

func _physics_process(delta: float) -> void:
	var direccion := Input.get_vector("ui_down", "ui_up","ui_left","ui_right")
	if direccion.x:
		velocity.y = -direccion.x * (velocidad * delta)
	else:
		velocity.y = lerp(velocity.y,0.0,0.3)
		
	if direccion.y:
		velocity.x = direccion.y * (velocidad * delta)
	else:
		velocity.x = lerp(velocity.x,0.0,0.3)
	
	#nos aseguramos de que el jugador mire al enemigo para poder atacar
	if raycast.is_colliding() and raycast.get_collider():
		if raycast.get_collider().is_in_group("enemigo"):
			puedeAtacar = true
			
	if !raycast.is_colliding():
		puedeAtacar = false
	
	#el jugador mira el mouse
	sprite.look_at(get_global_mouse_position()) 
	sprite.global_rotation += (PI/180*90)
	
	#si esta en las sombras y tiene energia y presiona esconderse
	if sombra == true and Input.is_action_just_pressed("Esconderse"):
		if !escondido and CoolDownSombra.value > 0.0:
			entrandoModoSombra()
		elif escondido:
			saliendoModoSombra()
	
	if escondido:
		if CoolDownSombra.value > 0:
			CoolDownSombra.value -= CoolDownRate
		
	if !escondido:
		if CoolDownSombra.value < 100:
			CoolDownSombra.value += CoolDownRate
	
	if escondido and !sombra or escondido and CoolDownSombra.value == 0:
		saliendoModoSombra()
	
	
	
	move_and_slide()
	
	if Input.is_action_just_pressed("click"):
		$AnimationPlayer.play("Ataque")

func recargarSombra():
	if CoolDownSombra.value < 100:
		CoolDownSombra.value += CantidadDeSangreAbsorvida
		

func EntroSombra():
	sombra = true

func SalioSombra():
	sombra = false

func entrandoModoSombra():
	sprite.visible = false
	guia.visible = true
	set_collision_mask_value(3,false)
	set_collision_layer_value(2,false)
	escondido = true
	
func saliendoModoSombra():
	sprite.visible = true
	guia.visible = false
	set_collision_mask_value(3,true)
	set_collision_layer_value(2,true)
	escondido = false


func crear_loop_flotar():
	#funcion de flotacion constante
	if !tweenflotacion:
		tweenflotacion = create_tween()
		tweenflotacion.set_ease(Tween.EASE_IN_OUT)
		tweenflotacion.set_trans(Tween.TRANS_CIRC)
		tweenflotacion.tween_property(sprite,"scale",sprite.scale*1.1,0.9)
		tweenflotacion.tween_property(sprite,"scale",sprite.scale*0.9,0.9)
		tweenflotacion.set_loops()

func die():
	#funcion de morir
	queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemigo"):
		body.die()
