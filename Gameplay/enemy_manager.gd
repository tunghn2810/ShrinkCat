extends Node

var waveCount = 0
var currentEnemyCount = 0

signal wave_finished
signal enemy_count_udpated

@onready var warningSign = preload("res://Enemies/WarningSign.tscn")


var enemyBasic : PackedScene = preload("res://Enemies/Enemy_Basic.tscn")
var enemyTrack : PackedScene = preload("res://Enemies/Enemy_Track.tscn")
var enemyCurved : PackedScene = preload("res://Enemies/Enemy_Curved.tscn")


func enemyReset():
	waveCount = 0

func spawnWarningSign():
	var newSign = warningSign.instantiate()
	get_tree().get_first_node_in_group('PlayArea').add_child(newSign)
	return newSign

func enemyPicker(type : int):
	if type == 1:
		return enemyBasic
	elif type == 2:
		return enemyTrack
	elif type == 3:
		return enemyCurved
	else:
		push_error("Enemy not found")
		return null
