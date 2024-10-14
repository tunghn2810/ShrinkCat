extends Node

var cardPath = "res://PowerUps/Cards/"

var powerList = [
	"speed_up",
	"size_down",
	"light_width_up",
	"light_length_up",
	"light_speed_up",
	"heal",
	"battery_up"
]

signal power_menu_opened
signal power_up_picked

func getRandomPowers(amount : int):
	var powerNames = Array()
	var count = 0
	while count < amount:
		var power = powerList.pick_random()
		if !powerNames.has(power):
			powerNames.append(power)
			count += 1

	var powers = Array()

	for	powerID in powerNames:
		var power = load(cardPath + powerID + ".tres")
		powers.append(power)

	return powers


func processPower(powerID : String):
	match powerID:
		"speed_up":
			PlayerManager.playerSpeedMultiplier += 0.2
		"size_down":
			PlayerManager.playerSizeMultiplier *= 0.95
			PlayerManager.player_size_updated.emit()
		"light_width_up":
			PlayerManager.lightWidthMultiplier += 0.5
			PlayerManager.light_width_updated.emit()
		"light_length_up":
			PlayerManager.lightLengthMultiplier += 0.2
			PlayerManager.light_length_updated.emit()
		"light_speed_up":
			#PlayerManager.lightShrinkRate -= 0.01 #0.01
			PlayerManager.lightShrinkRate += 0.001
		"heal":
			PlayerManager.player_health_gained.emit()
		"battery_up":
			PlayerManager.batteryDrainRateMultiplier -= 0.2
	
	power_up_picked.emit()
