extends Control

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
	if (!isPaused):
		GameManager.game_unpaused.emit()
