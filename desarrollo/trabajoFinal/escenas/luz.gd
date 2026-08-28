extends Node2D


func _on_detector_detectado(Jugador: CharacterBody2D) -> void:
	if Jugador.is_in_group("jugador"):
		Jugador.die()
