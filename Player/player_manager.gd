extends Node

var playerHealth = 3
signal is_player_damaged

var isPlayerLost = false
signal is_player_lost

var playerScore = 0
signal player_score_updated

var isFiring

var lightShrinkRate = 0.98
var isLightActive = false
var isLightOverheat = false
signal light_overheat

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
