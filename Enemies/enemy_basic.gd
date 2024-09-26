extends Enemy

func speedInit():
	speed = 100
	super.speedInit()

func scoreInit():
	score = 100
	super.scoreInit()

func setVelocity():
	velocity = direction.normalized() * speed
	setRotation()

func beginMoving():
	super.beginMoving()
	setVelocity()
