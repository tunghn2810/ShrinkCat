extends Control

@onready var pauseSFX : AudioStreamPlayer2D = $PauseSFX
@onready var bgm : AudioStreamPlayer2D = $"../../BGM"

func _input(event):
	if event.is_action_pressed("pause"):
		get_tree().paused = !get_tree().paused
		pauseGame(get_tree().paused)

	if event.is_action_pressed("fire"):
		PlayerManager.isFiring = true
	elif event.is_action_released("fire"):
		PlayerManager.isFiring = false

func pauseGame(isPaused : bool):
	visible = isPaused
	GameManager.isGamePaused = isPaused
	if isPaused:
		pauseSFX.play()
		bgm.stream_paused = true
	else:
		GameManager.game_unpaused.emit()
		bgm.stream_paused = false
