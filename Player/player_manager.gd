extends Node

var playerHealth = 3
signal is_player_damaged
signal player_health_gained

var isPlayerLost = false
signal is_player_lost

var playerScore = 0
signal player_score_updated

var isFiring

#var lightShrinkRate = 0.98
var lightShrinkRate = 0.008
var isLightActive = false
var isLightOverheat = false
signal light_overheat

signal light_length_updated
var lightLengthMultiplier = 1

signal light_width_updated
var lightWidthMultiplier = 1

var batteryDrainRateMultiplier = 1

signal player_size_updated
var playerSizeMultiplier = 1

var playerSpeedMultiplier = 1


func playerLose():
	isPlayerLost = true
	is_player_lost.emit()

func playerReset():
	playerHealth = 3
	isPlayerLost = false
	playerScore = 0

func increasePlayerScore(score):
	playerScore += score
	player_score_updated.emit()
