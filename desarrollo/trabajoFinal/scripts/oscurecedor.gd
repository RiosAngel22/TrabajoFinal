extends Area2D
class_name oscurecedor

@export var cercanos : Array[oscurecedor]
@onready var Oscurecedor = $Oscurecedor

var adentro = false
var cercano = false

var tweenTransicion

func _process(delta: float) -> void:
	if adentro or cercano:
		transparente()
		
	if !adentro and !cercano:
		oscuro()

func transparente():
	Transicionar(Color.TRANSPARENT)
	
func oscuro():
	Transicionar(Color.from_rgba8(129,0,105,255))

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		adentro = true
		await get_tree().create_timer(0.2).timeout
		for i in cercanos:
			i.cercano = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		adentro = false
		for i in cercanos:
			i.cercano = false

func Transicionar(color : Color)->void:
	tweenTransicion = create_tween()
	tweenTransicion.set_ease(Tween.EASE_OUT)
	tweenTransicion.set_trans(Tween.TRANS_EXPO)
	tweenTransicion.tween_property(Oscurecedor,"color",color,0.5)
	
	
	
