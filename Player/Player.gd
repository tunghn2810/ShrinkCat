extends CharacterBody2D


const SPEED : float = 100.0
var direction : Vector2
var directionX : float
var directionY : float

var lightRotateSpeed :float = 10
var lightTargetVector : Vector2

@onready var sprite : Sprite2D = $SpriteContainer/Sprite2D
@onready var loseSprite : AnimatedSprite2D = $LoseSprite
@onready var flash : Sprite2D = $Flash
@onready var light : Node2D = $Flash/Light

var normalTexture : Texture2D = preload("res://Player/CatBlob.png")
var hitTexture : Texture2D = preload("res://Player/CatBlob_Hit.png")
@onready var loseAnim : AnimatedSprite2D = $LoseSprite
@onready var enemyDetection : Area2D = $EnemyDetection
@onready var iFrameTimer : Timer = $iFrameTimer

@onready var anim : AnimationPlayer = $AnimationPlayer


func _ready():
	loseAnim.play()
	loseAnim.hide()
	PlayerManager.player_size_updated.connect(updateSize)

func _process(delta):
	if PlayerManager.isPlayerLost:
		return
	
	if velocity.length() > 0:
		anim.play("Move")
	else:
		anim.stop()
	
	if PlayerManager.isFiring && !PlayerManager.isLightActive && !PlayerManager.isLightOverheat:
		light.turnOn()
	elif !PlayerManager.isFiring && PlayerManager.isLightActive:
		light.turnOff()

func _physics_process(delta):
	if PlayerManager.isPlayerLost:
		return
		
	#Flashlight rotation
	#flash.look_at(get_global_mouse_position())
	#Smooth rotation
	lightTargetVector = get_global_mouse_position() - global_position
	flash.rotation = lerp_angle(flash.rotation, atan2(lightTargetVector.y, lightTargetVector.x), lightRotateSpeed * delta)
	
	#Movement
	directionX = Input.get_axis("move_left", "move_right")
	directionY = Input.get_axis("move_up", "move_down")
	direction = Vector2(directionX, directionY).normalized()
	
	velocity = direction * SPEED * PlayerManager.playerSpeedMultiplier
	
	if directionX > 0:
		sprite.flip_h = false
	elif directionX < 0:
		sprite.flip_h = true
	
	move_and_slide()

func getHit():
	sprite.texture = hitTexture
	$HitPlayer.play()
	
	PlayerManager.is_player_damaged.emit()
	
	enemyDetection.set_deferred("monitorable", false)
	enemyDetection.set_deferred("monitoring", false)
	
	if PlayerManager.playerHealth > 0:
		damageFlash()
		iFrameTimer.start()
	else:
		lose()

func damageFlash():
	sprite.modulate = Color(1, 1, 1, 0.3)
	await get_tree().create_timer(0.1).timeout
	sprite.modulate = Color.WHITE
	await get_tree().create_timer(0.1).timeout
	
	if (!iFrameTimer.is_stopped()):
		damageFlash()
	else:
		sprite.texture = normalTexture
		enemyDetection.set_deferred("monitorable", true)
		enemyDetection.set_deferred("monitoring", true)

func lose():
	#Death VFX
	#var death = deathVFX.instantiate()
	#get_tree().root.add_child(death)
	#death.transform = transform
	
	sprite.hide()
	loseAnim.show()
	
	PlayerManager.playerLose()
	
	light.turnOff()
	
	#Death SFX
	#$DeadPlayer.play()
	
	#Lose screen
	#$"../UI/LoseScreen".visible = true
	

func updateSize():
	sprite.scale *= PlayerManager.playerSizeMultiplier
	loseSprite.scale *= PlayerManager.playerSizeMultiplier
	enemyDetection.scale *= PlayerManager.playerSizeMultiplier

func _on_enemy_detection_body_entered(body):
	if body.is_in_group('Enemy'):
		getHit()
