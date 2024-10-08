extends Label

func _ready():
	updateWaveCount()
	PowerUpManager.power_up_picked.connect(updateWaveCount)

func updateWaveCount():
	text = "Wave  " + str(EnemyManager.waveCount + 1)
