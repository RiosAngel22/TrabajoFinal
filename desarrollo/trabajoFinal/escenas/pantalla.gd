extends Control
class_name pantalla

@onready var BotonVictoria : Button = $Victoria/Button
@onready var BotonDerrota : Button = $Derrota/Button

@export var Jugador : jugador 

func _ready() -> void:
	Jugador.gano.connect(mostrarVictoria)
	Jugador.perdio.connect(mostrarDerrota)

func mostrarVictoria():
	$Victoria.show()
	
func mostrarDerrota():
	$Derrota.show()

func reset():
	$Victoria.hide()
	$Derrota.hide()
	get_tree().reload_current_scene()
