extends Entity
class_name Enemy

@export var max_cooldown: int = 1

@onready var player: Player = get_node("../Player")

var current_cooldown: int = 0
	
func activate() -> bool:	
	if !ground_layer.get_used_rect().has_point(ground_layer.local_to_map(player.global_position)):
		return false
		
	var id_path = ground_layer.astar_grid.get_id_path(
		ground_layer.local_to_map(global_position),
		ground_layer.local_to_map(player.global_position)
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
	print(ground_layer.local_to_map(global_position), ground_layer.local_to_map(player.global_position))
	if ground_layer.is_cell_empty(ground_layer.map_to_local(id_path.front())):
		global_position = ground_layer.map_to_local(id_path.front())
		return true
		
	return false

func attack() -> bool:
	player.current_health -= 2
	$SoundsPlayer.stream = $SoundsPlayer.sword_enemy_sound
	$SoundsPlayer.play()
	return true
