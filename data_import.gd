extends Node

var path
var file

func _ready():
	readWaveData()

func readWaveData():
	path = "res://WaveData.txt"
	file = FileAccess.open(path, FileAccess.READ)
	
	#Skip title line
	file.get_line()
	
	var waveData : Array[String]
	var line = 0
	while file.get_position() < file.get_length():
		waveData.append(file.get_line())
		line += 1
	
	return waveData
