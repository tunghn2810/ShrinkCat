extends Control

@export var emptyHearts : Array[TextureRect]

func _ready():
	PlayerManager.is_player_damaged.connect(loseHealth)

func loseHealth():
	emptyHearts[PlayerManager.playerHealth].visible = true
