extends Label


func _ready():
	GameManager.game_started.connect(updateScore)
	PlayerManager.player_score_updated.connect(updateScore)

func updateScore():
	text = "%07d" % PlayerManager.playerScore
