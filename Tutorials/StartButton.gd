extends Area2D


var poofVFX : PackedScene = preload("res://Enemies/PoofVFX.tscn")
var isInLight = false

func _process(delta):
	if isInLight:
		scale *= 0.97
	
	if scale.x <= 0.1:
		startGame()

func startGame():
	var deathVFX = poofVFX.instantiate()
	get_tree().root.add_child(deathVFX)
	deathVFX.global_position = global_position
	deathVFX.play()
	
	GameManager.isGameStarted = true
	GameManager.game_started.emit()
	
	queue_free()


func _on_area_entered(area):
	if area.is_in_group('Light'):
		isInLight = true


func _on_area_exited(area):
	if area.is_in_group('Light'):
		isInLight = false
