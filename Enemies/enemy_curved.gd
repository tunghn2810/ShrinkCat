extends Enemy


const MAX_FORCE = 0.02

func setVelocity():
	velocity = steer()

func steer():
	var desiredVelocity = Vector2(target.global_position - global_position).normalized() * speed
	var steer = desiredVelocity - velocity
	return velocity + steer * MAX_FORCE
