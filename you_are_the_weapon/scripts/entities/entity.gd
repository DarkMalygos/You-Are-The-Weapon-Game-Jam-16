extends Area2D
class_name Entity

@export var max_health: int = 10
@export var health_bar: TextureProgressBar

@onready var ground_layer: GroundLayer = get_node("../TileMap/GroundLayer")
@onready var current_health: int = max_health:
	get:
		return current_health
	set(value):
		current_health = max(0, min(max_health, value))
		
		if current_health == 0:
			destroy()
		
		health_bar.value = current_health * 100 / max_health

func _ready() -> void:
	ground_layer.entities.append(self)
	
func destroy():
	push_warning("not implemented")
