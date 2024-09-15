extends Label

func _ready():
	updateEnemyCount()
	EnemyManager.enemy_count_udpated.connect(updateEnemyCount)

func updateEnemyCount():
	text = "ENEMIES LEFT:  " + str(EnemyManager.currentEnemyCount)
