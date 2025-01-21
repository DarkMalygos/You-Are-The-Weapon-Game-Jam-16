extends Area2D
class_name Entity

@export var max_health: int = 10

@onready var ground_layer: GroundLayer = get_node("../TileMap/GroundLayer")
@onready var current_health: int = max_health:
	get:
		return current_health
	set(value):
		current_health = max(0, min(max_health, value))
		print(current_health)

func _ready() -> void:
	ground_layer.entities.append(self)
