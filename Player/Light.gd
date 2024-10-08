extends Node2D

#Lerp timer for light on-off
var time : float = 0.0
var duration : float = 0.5
var t : float

var isTurnedOn : bool = false
var isLerping : bool = false

#Point light scale
var lightScaleX
var lightScaleY

#Area2D scale
var lightAreaScaleX
var lightAreaScaleY

var spaceState

@onready var light = $PointLight2D
@onready var lightArea = $Area2D

var enemiesInLight

func _ready():
	lightScaleX = light.scale.x
	lightScaleY = light.scale.y
	light.scale = Vector2.ZERO
	
	lightAreaScaleX = lightArea.scale.x
	lightAreaScaleY = lightArea.scale.y
	lightArea.scale = Vector2.ZERO
	
	PlayerManager.light_overheat.connect(turnOff)
	GameManager.game_unpaused.connect(turnOffOnUnpause)
	
	PlayerManager.light_length_updated.connect(upgradeLightLength)
	PlayerManager.light_width_updated.connect(upgradeLightWidth)

#func _process(delta):
	#Case for when one enemy blocks another
	#if isTurnedOn:
		#spaceState = get_world_2d().direct_space_state
		#enemiesInLight = lightArea.get_overlapping_bodies()
		#if enemiesInLight.size() > 0:
			#for enemy in enemiesInLight:
				#var params = PhysicsRayQueryParameters2D.new()
				#params.from = global_position
				#params.to = enemy.global_position
				#params.exclude = [self]
				#var rayResult = spaceState.intersect_ray(params)
				#if rayResult:
					#if rayResult.collider == enemy:
						#enemy.setInLight(true)
					#else:
						#enemy.setInLight(false)
	

func _physics_process(delta):
	if isLerping:
		t = time / duration
		
		if isTurnedOn:
			light.scale.x = lightScaleX
			light.scale = light.scale.lerp(Vector2(lightScaleX, lightScaleY), t)
			lightArea.scale.x = lightAreaScaleX
			lightArea.scale = lightArea.scale.lerp(Vector2(lightAreaScaleX, lightAreaScaleY), t)
		else:
			light.scale = light.scale.lerp(Vector2(light.scale.x, 0), t)
			lightArea.scale = lightArea.scale.lerp(Vector2(lightAreaScaleX, 0), t)
		
		time += delta
		
		if (time >= duration):
			if isTurnedOn:
				light.scale = Vector2(lightScaleX, lightScaleY)
				lightArea.scale = Vector2(lightAreaScaleX, lightAreaScaleY)
			else:
				light.scale = Vector2(0, 0)
				lightArea.scale = Vector2(0, 0)
				
				light.enabled = false
				lightArea.set_deferred("monitorable", false)
				
			isLerping = false
	

func upgradeLightLength():
	lightScaleX *= PlayerManager.lightLengthMultiplier
	lightAreaScaleX *= PlayerManager.lightLengthMultiplier

func upgradeLightWidth():
	lightScaleY *= PlayerManager.lightWidthMultiplier
	lightAreaScaleY *= PlayerManager.lightWidthMultiplier

func turnOn():
	time = 0
	isLerping = true
	isTurnedOn = true
	light.enabled = true
	lightArea.set_deferred("monitorable", true)
	PlayerManager.isLightActive = true

func turnOff():
	time = 0
	isLerping = true
	isTurnedOn = false
	PlayerManager.isLightActive = false

func turnOffOnUnpause():
	if (!PlayerManager.isFiring):
		turnOff()
