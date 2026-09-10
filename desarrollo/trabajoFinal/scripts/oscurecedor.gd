extends Area2D
class_name oscurecedor

@export var cercanos : Array[oscurecedor]

var adentro = false
var cercano = false

func _process(delta: float) -> void:
	if adentro:
		transparente()
		
	if !adentro and cercano:
		opaco()
		
	if !adentro and !cercano:
		oscuro()

func transparente():
	$Oscurecedor.color = Color.TRANSPARENT
	
func opaco():
	$Oscurecedor.color = Color.from_rgba8(0,0,0,125)
	
func oscuro():
	$Oscurecedor.color = Color.BLACK

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		adentro = true
	for i in cercanos:
		i.cercano = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		adentro = false
		for i in cercanos:
			i.cercano = false
