extends TextureButton

func _ready():
	PlayerManager.is_player_lost.connect(appear)

func appear():
	visible = true

func _on_button_up():
	get_tree().reload_current_scene()
	PlayerManager.playerReset()
	EnemyManager.enemyReset()
