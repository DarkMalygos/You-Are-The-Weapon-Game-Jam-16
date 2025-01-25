extends Area2D
class_name Entity

@export var max_health: int = 10
@export var health_bar: TextureProgressBar
@export var speed: int = 10

@onready var ground_layer: GroundLayer = get_node("../TileMap/GroundLayer")
@onready var current_health: int = max_health:
	get:
		return current_health
	set(value):
		current_health = max(0, min(max_health, value))
		
		if current_health == 0:
			destroy()
		
		health_bar.value = current_health * 100 / max_health
@onready var target_position: Vector2 = self.position

var is_moving: bool = false

func _ready() -> void:
	ground_layer.entities.append(self)
	
func _process(delta: float) -> void:
	if position.distance_to(target_position) < 5:
		position = target_position
		is_moving = false
		return
	
	var direction = Vector2(target_position - position).normalized()
	position += direction * speed
	
func destroy():
	push_warning("not implemented")
