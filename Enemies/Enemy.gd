extends CharacterBody2D

var direction
var collision

@onready var sprite = $Sprite2D

@onready var player = get_tree().get_first_node_in_group("Player")
@onready var playArea = get_tree().get_first_node_in_group("PlayArea")
@onready var rayCast = $RayCast2D
@onready var warningSign = $WarningSign
var maxDistanceToCollision = 0

var isInLight = false

var poofVFX : PackedScene = preload("res://Enemies/PoofVFX.tscn")

var score

signal enemy_defeated

func init(size, speed):
	
	sizeInit(size)
	direction = player.global_position - global_position
	PlayerManager.is_player_lost.connect(stopMoving)
	
	rayCast.set_target_position(direction)
	rayCast.enabled = true
	
	await get_tree().create_timer(3.0).timeout
	
	velocity = direction.normalized() * speed

func _process(delta):
	#sprite.look_at(global_position + velocity)
	
	if isInLight:
		scale *= PlayerManager.lightShrinkRate
	
	if scale.x <= 0.1:
		die()
	
	if rayCast.is_colliding():
		var collisionPoint = rayCast.get_collision_point()
		warningSign.global_position = collisionPoint
		var distanceToCollision = (global_position - collisionPoint).length()
		
		if maxDistanceToCollision == 0:
			maxDistanceToCollision = distanceToCollision
		
		#Warning sign base scale is 1.5
		warningSign.scale = Vector2(1.5,1.5) * ((distanceToCollision / maxDistanceToCollision)/2 + 0.5)
		

func _physics_process(delta):
	collision = move_and_collide(velocity * delta)
	sprite.rotation = velocity.angle()
	if collision:
		velocity = velocity.bounce(collision.get_normal())

func sizeInit(size):
	$Sprite2D.scale *= size
	$CollisionShape2D.scale *= size
	$LightOccluder2D.scale *= size

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


func _on_area_collider_area_entered(area):
	if area.is_in_group('Light'):
		isInLight = true
	if area.is_in_group('Warning'):
		rayCast.enabled = false
		warningSign.visible = false

func _on_area_collider_area_exited(area):
	if area.is_in_group('Light'):
		isInLight = false
