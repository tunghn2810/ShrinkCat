extends Node

var waveCount = 0
var currentEnemyCount = 0

signal wave_finished
signal enemy_count_udpated

@onready var warningSign = preload("res://Enemies/WarningSign.tscn")

func enemyReset():
	waveCount = 0

func spawnWarningSign():
	var newSign = warningSign.instantiate()
	get_tree().get_first_node_in_group('PlayArea').add_child(newSign)
	return newSign
