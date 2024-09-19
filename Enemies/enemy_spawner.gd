extends Node2D

@export var spawnArea : Array[ReferenceRect]
var enemy : PackedScene = preload("res://Enemies/Enemy_Track.tscn")
@onready var player = get_tree().get_first_node_in_group("Player")

@onready var spawnTimer = $SpawnTimer
@onready var waveIntervalTimer = $WaveInterval

var enemyToSpawn = 5
var isSpawning = false

const BASE_SIZE = 1
const BASE_SPEED = 100
const BASE_COUNT = 5
const BASE_SPAWN_INTERVAL = 3
const BASE_SCORE = 100

func _ready():
	randomize()
	
	PlayerManager.is_player_lost.connect(stopSpawning)
	GameManager.game_started.connect(startSpawning)

func startSpawning():
	enemyToSpawn = BASE_COUNT + EnemyManager.waveCount * 2
	
	EnemyManager.currentEnemyCount = enemyToSpawn
	EnemyManager.enemy_count_udpated.emit()
	
	spawnTimer.wait_time = BASE_SPAWN_INTERVAL - EnemyManager.waveCount * 0.2
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

func getEnemySize():
	var minSize = BASE_SIZE + EnemyManager.waveCount * 0.1
	var maxSize = minSize + EnemyManager.waveCount * 0.4
	return randf_range(minSize, maxSize)

func getEnemySpeed():
	var minSpeed = BASE_SPEED + EnemyManager.waveCount * 10
	var maxSpeed = minSpeed + EnemyManager.waveCount * 20
	return randf_range(minSpeed, maxSpeed)

func spawnEnemy():
	var newEnemy = enemy.instantiate()
	get_tree().get_first_node_in_group('PlayArea').add_child(newEnemy)
	newEnemy.global_position = getSpawnPosition()
	newEnemy.init(getEnemySize(), getEnemySpeed())
	newEnemy.score = 100 + EnemyManager.waveCount * randi_range(10, 20)
	newEnemy.enemy_defeated.connect(reduceEnemyCount)
	
	enemyToSpawn -= 1
	if enemyToSpawn <= 0:
		stopSpawning()

func reduceEnemyCount():
	EnemyManager.currentEnemyCount -= 1
	EnemyManager.enemy_count_udpated.emit()
	$EnemyDefeatedSFX.play()
	
	if (!isSpawning && EnemyManager.currentEnemyCount == 0):
		EnemyManager.waveCount += 1
		EnemyManager.wave_finished.emit()
		waveIntervalTimer.start()
		
		await waveIntervalTimer.timeout
		
		startSpawning()

func _on_timer_timeout():
	spawnEnemy()
