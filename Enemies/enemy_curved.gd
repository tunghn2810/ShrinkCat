extends Enemy

const MAX_FORCE = 0.02

func speedInit():
	speed = 120
	super.speedInit()

func scoreInit():
	score = 120
	super.scoreInit()

func setVelocity():
	velocity = steer()

func _physics_process(delta):
	if startMoving:
		setVelocity()
		setRotation()
		move_and_collide(velocity * delta)

func steer():
	var desiredVelocity = Vector2(target.global_position - global_position).normalized() * speed
	var steer = desiredVelocity - velocity
	return velocity + steer * MAX_FORCE
