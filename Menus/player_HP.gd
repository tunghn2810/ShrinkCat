extends Control

@export var emptyHearts : Array[TextureRect]

func _ready():
	PlayerManager.is_player_damaged.connect(loseHealth)
	PlayerManager.player_health_gained.connect(gainHealth)

func loseHealth():
	PlayerManager.playerHealth -= 1
	emptyHearts[PlayerManager.playerHealth].visible = true

func gainHealth():
	emptyHearts[PlayerManager.playerHealth].visible = false
	PlayerManager.playerHealth += 1
