extends Area2D
class_name Entity

@onready var ground_layer: GroundLayer = get_node("../TileMap/GroundLayer")

func _ready() -> void:
	ground_layer.entities.append(self)
