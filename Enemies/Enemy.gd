extends CharacterBody2D
class_name Enemy

var size
var speed
var score

var direction
var collision


var startMoving = false

@onready var sprite = $Sprite2D
@onready var collider = $CollisionShape2D
@onready var lightCollider = $LightOccluder2D

@onready var target = get_tree().get_first_node_in_group("Player")
@onready var playArea = get_tree().get_first_node_in_group("PlayArea")

@onready var shapeCast = $ShapeCast2D
var warningSign

var maxDistanceToCollision = 0

var isInLight = false

var poofVFX : PackedScene = preload("res://Enemies/PoofVFX.tscn")

signal enemy_defeated

func init():
	#Basic initialization
	sizeInit()
	speedInit()
	scoreInit()
	PlayerManager.is_player_lost.connect(stopMoving)
	
	#Temporarily disable collision with walls
	set_collision_mask_value(3, false)
	
	directionInit()
	
	await get_tree().create_timer(3.0).timeout
	
	beginMoving()

func _process(delta):
	if isInLight:
		#scale *= PlayerManager.lightShrinkRate
		scale -= Vector2.ONE * PlayerManager.lightShrinkRate
	
	if scale.x <= 0.1:
		die()
	
	if shapeCast.is_colliding():
		var collisionPoint = shapeCast.get_collision_point(0)
		
		if warningSign == null:
			warningSign = EnemyManager.spawnWarningSign()
			warningSign.global_position = collisionPoint
			
		var distanceToCollision = (global_position - collisionPoint).length()
		
		if maxDistanceToCollision == 0:
			maxDistanceToCollision = distanceToCollision
			
		#Warning sign base scale is 1.5
		warningSign.scale = Vector2(1.5,1.5) * ((distanceToCollision / maxDistanceToCollision)/2 + 0.2)
		

func _physics_process(delta):
	if startMoving:
		collision = move_and_collide(velocity * delta)
		if collision:
			velocity = velocity.bounce(collision.get_normal())
			setRotation()
			
func sizeInit():
	size = 1 + EnemyManager.waveCount * 0.05
	
	sprite.scale *= size
	collider.scale *= size
	lightCollider.scale *= size
	shapeCast.shape.radius *= size

func speedInit():
	speed += EnemyManager.waveCount * 10

func scoreInit():
	score += EnemyManager.waveCount * 5

func directionInit():
	direction = target.global_position - global_position
	shapeCast.set_target_position(direction)
	shapeCast.enabled = true

func beginMoving():
	startMoving = true

func setVelocity():
	#To be overridden
	pass

#Should be called with setVelocity
func setRotation():
	sprite.rotation = velocity.angle()

func die():
	var deathVFX = poofVFX.instantiate()
	get_tree().root.add_child(deathVFX)
	deathVFX.global_position = global_position
	deathVFX.play()
	enemy_defeated.emit()
	PlayerManager.increasePlayerScore(score)
	queue_free()

func setInLight(inLight):
	isInLight = inLight

func stopMoving():
	velocity = Vector2.ZERO
	startMoving = false

func _on_area_collider_area_entered(area):
	if area.is_in_group('Light'):
		isInLight = true
	
	if area.is_in_group('Warning'):
		if warningSign != null:
			warningSign.queue_free()
		shapeCast.enabled = false
		
		#Give back collision with walls once entered the play area
		set_collision_mask_value(3, true)

func _on_area_collider_area_exited(area):
	if area.is_in_group('Light'):
		isInLight = false
