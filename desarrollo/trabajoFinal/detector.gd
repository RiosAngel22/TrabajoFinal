extends Node2D
class_name detector

@onready var raycast : RayCast2D = $RayCast2D 

var jugador : CharacterBody2D

func _process(delta: float) -> void:
	if jugador:
		raycast.target_position = to_local(jugador.position)
		
		if raycast.get_collider() == jugador:
			print("se quemo")
		else:
			print("luz evitada")
		

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		jugador = body


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body == jugador:
		jugador = null
