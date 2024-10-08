extends Control

@export var powerCards : Array[PowerCard]

@onready var animPlayer : AnimationPlayer = $AnimationPlayer

func _ready():
	PowerUpManager.power_menu_opened.connect(openMenu)
	PowerUpManager.power_up_picked.connect(closeMenu)

func openMenu():
	animPlayer.play("menu_appear")
	GameManager.isGamePaused = true
	get_tree().paused = true
	setPowerCards()

func closeMenu():
	visible = false
	GameManager.isGamePaused = false
	get_tree().paused = false

func setPowerCards():
	var powers = PowerUpManager.getRandomPowers(powerCards.size())
	
	for i in range(powerCards.size()):
		powerCards[i].init(powers[i])
