extends Entity
class_name Player

enum States {MOVEMENT, WEAPON_SELECTION}

@export var zoom_speed: float = .1

@onready var ray_cast: RayCast2D = $RayCast2D
@onready var camera: Camera2D = $Camera2D
@onready var zoom_velocity: Vector2 = Vector2(zoom_speed, zoom_speed)
@onready var cell_size: int = ground_layer.tile_set.tile_size.x
@onready var inventory_container: HBoxContainer = $CanvasLayer/UI/Inventory.get_node("InventoryContainer")
@onready var slide_sound: AudioStreamWAV = preload("res://assets/sounds/slide.wav")

var direction_map: Dictionary = {"movement_right": Vector2.RIGHT, "movement_left": Vector2.LEFT, "movement_up": Vector2.UP, "movement_down": Vector2.DOWN}
var weapon_map: Dictionary = {"weapon_one": 0, "weapon_two": 1, "weapon_three": 2, "weapon_four": 3}
var selected_weapon: Weapon
var previous_state: States
var current_state: States = States.MOVEMENT:
	get:
		return current_state
	set(value):
		previous_state = current_state
		current_state = value

func _unhandled_input(event: InputEvent) -> void:
	if is_moving:
		return
	
	if event is InputEventMouseButton:
		if event.pressed:
			if event.button_index == MOUSE_BUTTON_LEFT:
				if current_state == States.WEAPON_SELECTION:
					selected_weapon.activate(ground_layer.local_to_map(get_global_mouse_position()))
	
	for weapon: String in weapon_map.keys():
		if event.is_action_pressed(weapon):
			if try_select(weapon):
				current_state = States.WEAPON_SELECTION
			else:
				current_state = States.MOVEMENT
	
	if current_state == States.MOVEMENT:
		for direction: String in direction_map.keys():
			if event.is_action_pressed(direction):
				move(direction)
				ground_layer.move_enemies()
			
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			camera.zoom += Vector2(.1, .1)
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			camera.zoom -= Vector2(.1, .1)

func move(direction: String):
	if is_moving:
		return
	
	ray_cast.target_position = direction_map[direction] * cell_size
	ray_cast.force_raycast_update()
	if !ray_cast.is_colliding():
		target_position = position + direction_map[direction] * cell_size
		SoundManager.play_sound($SoundsPlayer, slide_sound)
	is_moving = true

func try_select(new_weapon_key: String) -> bool:
	if inventory_container.get_child_count() < weapon_map[new_weapon_key] + 1:
		return false
	
	var new_weapon: Weapon = inventory_container.get_child(weapon_map[new_weapon_key])
	
	return select(new_weapon)

func on_weapon_mouse_down(weapon: Weapon):
	if select(weapon):
		current_state = States.WEAPON_SELECTION
	else:
		current_state = States.MOVEMENT
	
func select(new_weapon: Weapon) -> bool:
	for node in inventory_container.get_children():
		node.deselect()
	
	if new_weapon == selected_weapon:
		selected_weapon = null
		new_weapon.deselect()
		return false
	
	if new_weapon.current_cooldown > 0:
		return false
	
	selected_weapon = new_weapon
	new_weapon.select(ground_layer.local_to_map(position))
	$AnimatedSprite2D.animation = new_weapon.sprite_name
	return true

func try_add_weapon(weapon: Weapon):
	if inventory_container.get_child_count() > 3:
		inventory_container.remove_child(inventory_container.get_child(0))
		
	inventory_container.add_child(weapon)

func update_weapon_cooldowns():
	for weapon: Weapon in inventory_container.get_children():
		weapon.current_cooldown -= 1

func destroy():
	return
