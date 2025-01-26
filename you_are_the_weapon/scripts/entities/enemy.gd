extends Entity
class_name Enemy

@export var max_cooldown: int = 1

# For later, It's not implemented yet
@onready var left_bound = Vector2i(-4, 4)
@onready var right_bound = Vector2i(4, 4)
@onready var player: Player = get_node("../Player")
@onready var sounds: Dictionary = {
	"movement": preload("res://assets/sounds/slide.wav"),
	"attack": preload("res://assets/sounds/sword_enemy.wav")
}

var current_cooldown: int = 0
var packed_weapon: PackedScene

enum States {
	WANDER,
	COMBAT
}

var current_state: States = States.WANDER

func _ready() -> void:
	packed_weapon = preload("res://scenes/weapons/chain_morning_star.tscn")
	
	super._ready()

func activate() -> bool:
	if !ground_layer.get_used_rect().has_point(ground_layer.local_to_map(player.global_position)):
		return false
		
	var id_path = ground_layer.astar_grid.get_id_path(
		ground_layer.local_to_map(target_position),
		ground_layer.local_to_map(player.target_position)
	).slice(1)

	if id_path.is_empty():			
		return false
		
	if current_cooldown == max_cooldown:
		current_cooldown -= 1
		return true
		
	if id_path.size() < 2:
		if attack():
			current_cooldown = max_cooldown
			return true
			
		return false
		
	if move(id_path):
		return true
		
	return false

func move(id_path: Array[Vector2i]) -> bool:
	if id_path.size() < 4:
		current_state = States.COMBAT
		
	var new_position = id_path.front()
	if current_state == States.COMBAT && !ground_layer.get_entity_at(ground_layer.map_to_local(new_position)):
		target_position = ground_layer.map_to_local(new_position)
		SoundManager.play_sound($SoundsPlayer, sounds["movement"])
		return true
		
	return false

func attack() -> bool:
	player.current_health -= 2
	SoundManager.play_sound($SoundsPlayer, sounds["attack"])
	$AnimatedSprite2D.play("attack")
	return true

func destroy():
	player.try_add_weapon(packed_weapon.instantiate())
	
	super.destroy()
