extends Label

func _ready():
	updateWaveCount()
	EnemyManager.wave_finished.connect(updateWaveCount)

func updateWaveCount():
	text = "Wave  " + str(EnemyManager.waveCount + 1)
