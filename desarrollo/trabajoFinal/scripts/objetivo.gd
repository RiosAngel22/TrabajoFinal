extends StaticBody2D

@onready var Icono : icono = $icono
@onready var Rey : Sprite2D = $Sprite2D


@export_range(0,360) var AnguloIcono : float = 0

var TweenIcono

func _ready() -> void:
	Rey.material.set_shader_parameter("color", Color.TRANSPARENT)
	Icono.ocultar()

func _on_area_2d_body_entered(body: Node2D) -> void:
	Rey.material.set_shader_parameter("color", Color.RED)
	Icono.mostrar()

func _on_area_2d_body_exited(body: Node2D) -> void:
	Rey.material.set_shader_parameter("color", Color.TRANSPARENT)
	Icono.ocultar()
