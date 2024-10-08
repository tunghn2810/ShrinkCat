extends Node2D

@export var spawnArea : Array[ReferenceRect]
@onready var player = get_tree().get_first_node_in_group("Player")

@onready var spawnTimer = $SpawnTimer
@onready var waveIntervalTimer = $WaveInterval

var waveData : Array[String]
var currentWave : PackedStringArray
var enemiesToSpawn : Array[int]
var isSpawning = false

const BASE_SPAWN_INTERVAL = 3

func _ready():
	randomize()
	
	PlayerManager.is_player_lost.connect(stopSpawning)
	GameManager.game_started.connect(startSpawning)
	
	waveData = DataImport.readWaveData()

func startSpawning():
	#20 preset waves
	if EnemyManager.waveCount < 20:
		currentWave = waveData[EnemyManager.waveCount].split("\t")
	else: #After wave 20, uses wave 20 as the base
		currentWave = waveData[19].split("\t")
		
	#0 is wave numbering, 4 is cheese, and 5 is total
	for i in range(1,4):
		for j in range(int(currentWave[i])): #range is the number of unit for each type
			enemiesToSpawn.append(i)
		
		#After wave 20 only
		if EnemyManager.waveCount >= 20:
			#From wave 21 to 25, add 1 of each type
			if EnemyManager.waveCount < 25:
				enemiesToSpawn.append(i)
			#From wave 26 onwards, add 2 of each type
			else:
				enemiesToSpawn.append(i)
				enemiesToSpawn.append(i)
	
	enemiesToSpawn.shuffle()
	
	EnemyManager.currentEnemyCount = enemiesToSpawn.size()
	EnemyManager.enemy_count_udpated.emit()
	
	var spawnInterval = BASE_SPAWN_INTERVAL - EnemyManager.waveCount * 0.1
	
	spawnInterval = clampf(spawnInterval, 0.5, BASE_SPAWN_INTERVAL)
	
	spawnTimer.wait_time = spawnInterval
	isSpawning = true
	spawnTimer.start()
	

func stopSpawning():
	isSpawning = false
	spawnTimer.stop()

func getSpawnPosition():
	var area = spawnArea.pick_random()
	var rect = area.get_rect()
	var x = randf_range(rect.position.x, rect.position.x + rect.size.x)
	var y = randf_range(rect.position.y, rect.position.y + rect.size.y)
	return Vector2(x,y)

func spawnEnemy():
	var newEnemy = EnemyManager.enemyPicker(enemiesToSpawn[0]).instantiate()
	enemiesToSpawn.pop_front()
	
	get_tree().get_first_node_in_group('PlayArea').add_child(newEnemy)
	newEnemy.global_position = getSpawnPosition()
	newEnemy.init()
	newEnemy.enemy_defeated.connect(reduceEnemyCount)
	
	if enemiesToSpawn.size() <= 0:
		stopSpawning()

func reduceEnemyCount():
	EnemyManager.currentEnemyCount -= 1
	EnemyManager.enemy_count_udpated.emit()
	$EnemyDefeatedSFX.play()
	
	if (!isSpawning && EnemyManager.currentEnemyCount == 0):
		EnemyManager.waveCount += 1
		EnemyManager.wave_finished.emit()
		
		#Pause before power-up menu
		waveIntervalTimer.start()
		await waveIntervalTimer.timeout
		
		PowerUpManager.power_menu_opened.emit()
		#Wait until player picks a power-up
		await PowerUpManager.power_up_picked
		
		startSpawning()

func _on_timer_timeout():
	spawnEnemy()
