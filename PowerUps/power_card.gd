extends Control
class_name PowerCard

@onready var title = $Control/Title
@onready var icon = $Control/Icon
@onready var description = $Control/Description

var power : PowerUpResource

var isHovered = false

func init(p_power : PowerUpResource):
	power = p_power
	
	title.text = power.title
	icon.texture = power.icon
	description.text = power.description

func _on_mouse_entered():
	scale = Vector2.ONE * 1.25
	isHovered = true

func _on_mouse_exited():
	scale = Vector2.ONE
	isHovered = false


func _on_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed():
				set_deferred("modulate", Color(0.75, 0.75, 0.75))
			else:
				set_deferred("modulate", Color(1, 1, 1))
			
			if event.is_released() and isHovered:
				PowerUpManager.processPower(power.getID())
