extends Node2D

const MAX_BATTERY_LIFE = 100
var currentBatteryLife = 100
var batteryDrainRate = 25
var batteryRecoverRate = 50

@onready var gauge = $Gauge
@onready var overheat = $Overheat
var heatLerpColor = Color(1, 1, 1, 0.5)

func _process(delta):
	if !GameManager.isGameStarted:
		return
	
	if (PlayerManager.isLightActive):
		currentBatteryLife -= batteryDrainRate * delta
	else:
		currentBatteryLife += batteryRecoverRate * delta
	
	if (currentBatteryLife <= 0):
		PlayerManager.isLightOverheat = true
		PlayerManager.light_overheat.emit()
		overheat.visible = true
	elif (currentBatteryLife >= MAX_BATTERY_LIFE):
		PlayerManager.isLightOverheat = false
		overheat.visible = false
	
	currentBatteryLife = clamp(currentBatteryLife, 0, MAX_BATTERY_LIFE)
	updateBattery()
	
	if PlayerManager.isLightOverheat:
		overheatFlash()
	
func updateBattery():
	var batteryPercent = currentBatteryLife / MAX_BATTERY_LIFE
	gauge.scale.y = batteryPercent
	if (batteryPercent > 0.75):
		gauge.self_modulate = ColorPalette.green.lerp(ColorPalette.yellow,  1 - 4 * (batteryPercent - 0.75))
	elif (batteryPercent > 0.5):
		gauge.self_modulate = ColorPalette.yellow.lerp(ColorPalette.orange, 1 - 4 * (batteryPercent - 0.5))
	elif (batteryPercent > 0.25):
		gauge.self_modulate = ColorPalette.orange.lerp(ColorPalette.red, 1 - 4 * (batteryPercent - 0.25))

func overheatFlash():
	overheat.self_modulate = heatLerpColor.lerp(Color.WHITE, sin(TimeManager.time * 10))
