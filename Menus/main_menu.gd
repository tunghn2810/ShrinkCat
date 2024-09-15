extends Control

@export var gameUI : Control
@export var mainMenu : Control

func _ready():
	GameManager.game_started.connect(showGameUI)

func showGameUI():
	gameUI.visible = true
	mainMenu.visible = false
