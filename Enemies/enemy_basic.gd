extends Enemy


func setVelocity():
	velocity = direction.normalized() * speed
