extends Control
class_name pantalla

@onready var BotonVictoria : Button = $Victoria/Button
@onready var BotonDerrota : Button = $Derrota/Button

@export var Jugador : jugador 

var mostrandoGuia = false

func _ready() -> void:
	Jugador.gano.connect(mostrarVictoria)
	Jugador.perdio.connect(mostrarDerrota)
	Jugador.menu.connect(mostrarGuia)

func mostrarGuia()->void:
	if mostrandoGuia:
		$Guia.hide()
		mostrandoGuia = false
	else:
		$Guia.show()
		mostrandoGuia = true

func mostrarVictoria()->void:
	$Victoria.show()
	
func mostrarDerrota()->void:
	$Derrota.show()

func restart()->void:
	$Victoria.hide()
	$Derrota.hide()
	get_tree().change_scene_to_file("res://escenas/mundo.tscn")

func reset()->void:
	$Victoria.hide()
	$Derrota.hide()
	get_tree().reload_current_scene()
