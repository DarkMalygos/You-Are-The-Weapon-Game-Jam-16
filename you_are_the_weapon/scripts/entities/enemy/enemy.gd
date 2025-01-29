extends Entity
class_name Enemy

@export var max_cooldown: int = 3
@export var damage: int = 1
@export var attack_range: int = 1
@export var attack_sound: AudioStreamWAV

# For later, It's not implemented yet
@onready var left_bound = Vector2i(-4, 4)
@onready var right_bound = Vector2i(4, 4)
@onready var player: Player = get_node("../Player")
@onready var movement_sound: AudioStreamWAV = preload("res://assets/sounds/slide.wav")
#@onready var player_collision: CollisionShape2D = get_node("/root/Game/Player/CollisionShape2D")

var current_cooldown: int = 0:
	set(value):
		current_cooldown = max(0, value)
		
var packed_weapon: PackedScene

enum States {WANDER, WARNING, COMBAT}

var current_state: States = States.WANDER

func activate() -> bool:	
	if current_cooldown > 0:
		current_cooldown -= 1
		return true
	
	if !ground_layer.get_used_rect().has_point(ground_layer.local_to_map(player.global_position)):
		return false
	
	var id_path = ground_layer.astar_grid.get_id_path(
		ground_layer.local_to_map(target_position),
		ground_layer.local_to_map(player.target_position)
	).slice(1)

	if id_path.is_empty():
		return true
		
	if id_path.size() < attack_range + 1:
		attack()
		current_cooldown = max_cooldown
		return true
		
	move(id_path)
		
	return true

func move(id_path: Array[Vector2i]):
	if id_path.size() < 4:
		$RayCast2D.target_position = player.target_position - target_position
		$RayCast2D.force_raycast_update()
		var collider = $RayCast2D.get_collider()
		if collider == null:
			current_state = States.COMBAT
			$Sprite2D.visible = false
	
	if id_path.size() == 4:
		current_state = States.WARNING
		$Sprite2D.visible = true
		
	if id_path.size() > 4:
		current_state == States.WANDER
		$Sprite2D.visible = false
	
	var new_position = id_path.front()
	if current_state == States.COMBAT && !ground_layer.get_entity_at(ground_layer.map_to_local(new_position)):
		target_position = ground_layer.map_to_local(new_position)
		SoundManager.play_sound($SoundsPlayer, movement_sound)

func attack():
	player.current_health -= damage
	SoundManager.play_sound($SoundsPlayer, attack_sound)
	#$AnimatedSprite2D.play("attack")

func destroy():
	player.try_add_weapon(packed_weapon.instantiate())
	
	super.destroy()
