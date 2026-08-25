extends CharacterBody2D
class_name jugador

@onready var sprite : Sprite2D = $Sprite2D

@export var velocidad = 5000.0
var rotacionActual : float = 0

var tweenflotacion : Tween

func _ready() -> void:
	crear_loop_flotar()

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
	
	
	
	sprite.look_at(get_global_mouse_position()) 
	sprite.global_rotation += (PI/180*90)

	move_and_slide()

func crear_loop_flotar():
	if !tweenflotacion:
		tweenflotacion = create_tween()
		tweenflotacion.set_ease(Tween.EASE_IN_OUT)
		tweenflotacion.set_trans(Tween.TRANS_CIRC)
		tweenflotacion.tween_property(sprite,"scale",sprite.scale*1.1,0.9)
		tweenflotacion.tween_property(sprite,"scale",sprite.scale*0.9,0.9)
		tweenflotacion.set_loops()

func die():
	queue_free()
