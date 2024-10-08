extends Resource

class_name PowerUpResource

@export var title : String
@export var icon : Texture2D
@export var description : String


func getID():
	return resource_path.get_file().trim_suffix('.tres')
