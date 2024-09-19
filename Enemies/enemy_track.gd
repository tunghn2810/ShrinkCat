extends Enemy

@onready var forward = $Sprite2D/Forward
var rotateSpeed : float = 3

var moveTime : float = 5
var rotateTime : float = 3
var rotating : bool = false

func turn():
	sprite.rotation = lerp_angle(sprite.rotation, atan2(direction.y, direction.x), rotateSpeed * get_physics_process_delta_time())

func beginMoving():
	super.beginMoving()
	
	#await get_tree().create_timer(moveTime).timeout
	
	#beginTracking()

func beginTracking():
	stopMoving()
	rotating = true
	
	await get_tree().create_timer(rotateTime).timeout
	
	beginMoving()
	rotating = false
	direction = forward.global_position - global_position

func _physics_process(delta):
	super._physics_process(delta)
	
	if rotating:
		turn()

func setVelocity():
	velocity = direction.normalized() * speed
