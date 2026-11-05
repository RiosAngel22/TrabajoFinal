extends CharacterBody2D
class_name jugador
@export var velocidad = 5000.0

@onready var sprite : Sprite2D = $Sprite2D
@onready var guia : Polygon2D = $Polygon2D
@onready var raycast : RayCast2D = $Sprite2D/RayCast2D
@onready var CoolDownSombra : TextureProgressBar = $CanvasLayer/TextureProgressBar

@onready var iconoSombra : icono = $icono

@export var CoolDownRate : float = 0.1
@export var CantidadDeSangreAbsorvida : float = 30



var rotacionActual : float = 0
var tweenflotacion : Tween

var puedeAtacar := false
var sombra := false
var escondido := false

signal gano
signal perdio
signal menu

var vida : float = 100.0

func _ready() -> void:
	crear_loop_flotar()

func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("menu"):
		menu.emit()

func _physics_process(delta: float) -> void:
	#movimiento
	var direccion := Input.get_vector("ui_down", "ui_up","ui_left","ui_right")
	if direccion.x:
		velocity.y = -direccion.x * (velocidad * delta)
	else:
		velocity.y = lerp(velocity.y,0.0,0.3)
		
	if direccion.y:
		velocity.x = direccion.y * (velocidad * delta)
	else:
		velocity.x = lerp(velocity.x,0.0,0.3)
	
	if Input.is_action_just_pressed("dash"):
		velocidad = velocidad * 2
		await get_tree().create_timer(0.4).timeout
		velocidad = velocidad / 2
	
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
	
	#vaciar energia
	if escondido:
		if CoolDownSombra.value > 0:
			CoolDownSombra.value -= CoolDownRate
			
	#llenar energia
	if !escondido:
		if CoolDownSombra.value < 100:
			CoolDownSombra.value += CoolDownRate
	
	#icono si estamos pisando las sombras
	if sombra == true and escondido == false and CoolDownSombra.value > 0.0:
		iconoSombra.mostrar()
	else:
		iconoSombra.ocultar()
	
	if escondido and !sombra or escondido and CoolDownSombra.value == 0:
		saliendoModoSombra()
	
	
	$CanvasLayer/ProgressBar.value = vida
	
	move_and_slide()
	
	if Input.is_action_just_pressed("click"):
		$AnimationPlayer.play("Ataque")

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
	
	iconoSombra.ocultar()
	
func saliendoModoSombra():
	sprite.visible = true
	guia.visible = false
	set_collision_mask_value(3,true)
	set_collision_layer_value(2,true)
	escondido = false


func crear_loop_flotar():
	#funcion de flotacion constante del personaje
	if !tweenflotacion:
		tweenflotacion = create_tween()
		tweenflotacion.set_ease(Tween.EASE_IN_OUT)
		tweenflotacion.set_trans(Tween.TRANS_CIRC)
		tweenflotacion.tween_property(sprite,"scale",sprite.scale*1.1,0.9)
		tweenflotacion.tween_property(sprite,"scale",sprite.scale*0.9,0.9)
		tweenflotacion.set_loops()

func hit(daño : float)->void:
	vida -= daño
	if vida < 1:
		vida = 0
		die()
	
func heal(curacion : float)->void:
	vida += curacion
	if vida > 100:
		vida = 100

func die():
	#funcion de morirz
	perdio.emit()
	queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemigo"):
		body.die()
		#al matar enemigo, nos curamos
		heal(10)
		$AudioStreamPlayer2D.play()
		
	elif body.is_in_group("rey"):
		if body.Final:
			gano.emit()
		elif !body.Final:
			body.cambiarDeEscena()
