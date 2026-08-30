extends StaticBody2D

@onready var Icono : Sprite2D = $Icono
@onready var Rey : Sprite2D = $Sprite2D

@export_range(0,360) var AnguloIcono : float = 0

var TweenIcono

func _ready() -> void:
	crear_loop_flotar()
	Rey.material.set_shader_parameter("color", Color.TRANSPARENT)

	Icono.global_position = Vector2(global_position.x,global_position.y-50)
	Icono.global_rotation_degrees = AnguloIcono

func crear_loop_flotar():
	if !TweenIcono:
		TweenIcono = create_tween()
		TweenIcono.set_ease(Tween.EASE_IN_OUT)
		TweenIcono.set_trans(Tween.TRANS_CIRC)
		TweenIcono.tween_property(Icono,"scale",Icono.scale*1.1,0.9)
		TweenIcono.tween_property(Icono,"scale",Icono.scale*0.9,0.9)
		TweenIcono.set_loops()


func _on_area_2d_body_entered(body: Node2D) -> void:
	Rey.material.set_shader_parameter("color", Color.RED)
	Icono.visible = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	Rey.material.set_shader_parameter("color", Color.TRANSPARENT)
	Icono.visible = false
