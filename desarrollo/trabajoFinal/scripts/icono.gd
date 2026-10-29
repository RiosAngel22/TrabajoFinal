extends Node2D
class_name icono

@export var textura : Texture2D

@export var Offset : Vector2
@export_range(-360,360) var Angulo : float

var sprite : Sprite2D
var tweenSprite : Tween

func _ready() -> void:
	sprite = Sprite2D.new()
	add_child(sprite)
	sprite.global_position = Vector2(get_parent().global_position.x - Offset.x,get_parent().global_position.y - Offset.y)
	sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	sprite.texture = textura
	
	crear_loop()

func _process(delta: float) -> void:
	global_rotation_degrees = 0
	sprite.global_position = Vector2(get_parent().global_position.x - Offset.x,get_parent().global_position.y - Offset.y)


func mostrar():
	sprite.visible = true
	
func ocultar():
	sprite.visible = false

func crear_loop():
	if !tweenSprite:
		tweenSprite = create_tween()
		tweenSprite.set_ease(Tween.EASE_IN_OUT)
		tweenSprite.set_trans(Tween.TRANS_CIRC)
		tweenSprite.tween_property(sprite,"scale",sprite.scale*1.1,0.9)
		tweenSprite.tween_property(sprite,"scale",sprite.scale*0.9,0.9)
		tweenSprite.set_loops()
