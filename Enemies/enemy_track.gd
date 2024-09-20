extends Enemy

@onready var forward = $Sprite2D/Forward
var targetVector : Vector2
var rotateSpeed : float = 3

var moveTime : float = 5
var rotateTime : float = 3
var rotating : bool = false

@onready var lightAnim : AnimationPlayer = $Sprite2D/Light/AnimationPlayer

func turn():
	targetVector = target.global_position - global_position
	sprite.rotation = lerp_angle(sprite.rotation, atan2(targetVector.y, targetVector.x), rotateSpeed * get_physics_process_delta_time())

func beginMoving():
	super.beginMoving()
	setVelocity()
	setRotation()
	
	await get_tree().create_timer(moveTime).timeout
	
	beginTracking()

func resumeMoving():
	super.beginMoving()
	setVelocity()
	
	await get_tree().create_timer(moveTime).timeout
	
	beginTracking()

func beginTracking():
	stopMoving()
	rotating = true
	lightAnim.play("Flash")
	
	await get_tree().create_timer(rotateTime).timeout
	
	direction = forward.global_position - global_position
	resumeMoving()
	rotating = false
	lightAnim.stop()

func _physics_process(delta):
	super._physics_process(delta)
	
	if rotating:
		turn()

func setVelocity():
	velocity = direction.normalized() * speed
