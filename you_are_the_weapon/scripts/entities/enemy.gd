extends Entity
class_name Enemy

@onready var player: Player = get_node("../Player")
	
func move():	
	if !ground_layer.get_used_rect().has_point(ground_layer.local_to_map(player.global_position)):
		return
		
	var id_path = ground_layer.astar_grid.get_id_path(
		ground_layer.local_to_map(global_position),
		ground_layer.local_to_map(player.global_position)
	).slice(1)

	if id_path.is_empty():
		return

	if ground_layer.is_cell_empty(ground_layer.map_to_local(id_path.front())):
		global_position = ground_layer.map_to_local(id_path.front())
