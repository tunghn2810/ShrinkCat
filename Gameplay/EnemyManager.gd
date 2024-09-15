extends Node

var waveCount = 0
var currentEnemyCount = 0

signal wave_finished
signal enemy_count_udpated

func enemyReset():
	waveCount = 0
