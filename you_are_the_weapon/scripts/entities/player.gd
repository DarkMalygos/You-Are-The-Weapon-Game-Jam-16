extends Entity
class_name Player

@export var zoom_speed: float = .1

@onready var ray_cast: RayCast2D = $RayCast2D
@onready var camera: Camera2D = $Camera2D
@onready var zoom_velocity: Vector2 = Vector2(zoom_speed, zoom_speed)
@onready var cell_size := ground_layer.tile_set.tile_size.x

var inputs: Dictionary = {"movement_right": Vector2.RIGHT, "movement_left": Vector2.LEFT, "movement_up": Vector2.UP, "movement_down": Vector2.DOWN}

func _unhandled_input(event: InputEvent) -> void:
	for direction: String in inputs.keys():
		if event.is_action_pressed(direction):
			move(direction)
			ground_layer.move_enemies()
			
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			camera.zoom += Vector2(.1, .1)
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			camera.zoom -= Vector2(.1, .1)

func move(direction: String):
	ray_cast.target_position = inputs[direction] * cell_size
	ray_cast.force_raycast_update()
	if !ray_cast.is_colliding():
		position += inputs[direction] * cell_size
