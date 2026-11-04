extends Node2D
class_name detector

@export var raycast : RayCast2D
@export var area : Area2D

signal Detectado(jugador:CharacterBody2D)
signal Perdido

var jugador : CharacterBody2D

func _ready() -> void:
	area.body_entered.connect(_on_area_2d_body_entered)
	area.body_exited.connect(_on_area_2d_body_exited)

func _process(delta: float) -> void:
	#detecta y sigue al jugador, si entra en rango, notifica
	if jugador:
		raycast.target_position = to_local(jugador.position)
		
		if raycast.get_collider() == jugador:
			Detectado.emit(jugador)

		else:
			return
		

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		jugador = body


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body == jugador:
		jugador = null
		if self != null:
			Perdido.emit()
