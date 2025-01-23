extends Entity
class_name Player

@export var zoom_speed: float = .1

@onready var ray_cast: RayCast2D = $RayCast2D
@onready var camera: Camera2D = $Camera2D
@onready var zoom_velocity: Vector2 = Vector2(zoom_speed, zoom_speed)
@onready var cell_size: int = ground_layer.tile_set.tile_size.x
@onready var inventory_container: HBoxContainer = $CanvasLayer/UI/Inventory.get_node("HBoxContainer")

var direction_map: Dictionary = {"movement_right": Vector2.RIGHT, "movement_left": Vector2.LEFT, "movement_up": Vector2.UP, "movement_down": Vector2.DOWN}
var weapon_map: Dictionary = {"weapon_one": 0, "weapon_two": 1, "weapon_three": 2, "weapon_four": 3}
var selected_weapon: Weapon

func _unhandled_input(event: InputEvent) -> void:
	for direction: String in direction_map.keys():
		if event.is_action_pressed(direction):
			move(direction)
			ground_layer.move_enemies()
			
	for weapon: String in weapon_map.keys():
		if event.is_action_pressed(weapon):
			try_select(weapon)
			
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			camera.zoom += Vector2(.1, .1)
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			camera.zoom -= Vector2(.1, .1)

func move(direction: String):
	ray_cast.target_position = direction_map[direction] * cell_size
	ray_cast.force_raycast_update()
	if !ray_cast.is_colliding():
		position += direction_map[direction] * cell_size
		$SoundsPlayer.play()

func try_select(new_weapon_key: String):
	if inventory_container.get_child_count() < weapon_map[new_weapon_key] + 1:
		return
	
	var new_weapon: Weapon
	
	for node in inventory_container.get_children():
		if node is Weapon:
			node.deselect()

	new_weapon = inventory_container.get_child(weapon_map[new_weapon_key])

	if new_weapon != selected_weapon:
		selected_weapon = new_weapon
		new_weapon.select()
		return

	selected_weapon = null
	new_weapon.deselect()
