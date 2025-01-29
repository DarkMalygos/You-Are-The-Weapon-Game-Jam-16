extends Weapon
class_name Axe

var secondary_valid_cell_ids: Array[Vector2i]

func show_valid_cells(cell_id: Vector2i):
	secondary_valid_cell_ids = ground_layer.get_cell_ids_diagonal(cell_id, weapon_range)
	
	for secondary_valid_cell_id in secondary_valid_cell_ids:
		valid_tile_hint_layer.set_cell(secondary_valid_cell_id, 0, Vector2i(3, 0))
		
	super.show_valid_cells(cell_id)
	
func hide_valid_cells():
	for secondary_valid_cell_id in secondary_valid_cell_ids:
		valid_tile_hint_layer.set_cell(secondary_valid_cell_id)
		
	secondary_valid_cell_ids.clear()
	
	super.hide_valid_cells()

func activate(target_cell_id: Vector2i):
	if !valid_cell_ids.has(target_cell_id):
		return
		
	var player_cell_id: Vector2i = ground_layer.local_to_map(player.position)
		
	if target_cell_id.x < player_cell_id.x || target_cell_id.x > player_cell_id.x:
		attack_entities_in_line(target_cell_id, Vector2i(0, 1))
		
	if target_cell_id.y < player_cell_id.y || target_cell_id.y > player_cell_id.y:
		attack_entities_in_line(target_cell_id, Vector2i(1, 0))

func attack_entities_in_line(center_cell_id: Vector2i, axis_vector: Vector2i):
	var entity_position: Vector2
	var current_entity: Entity
	var x_position: int
	var y_posiiton: int
	var is_successful: bool = false
	
	for axis in range(-1, 2):
		x_position = center_cell_id.x + axis * axis_vector.x
		y_posiiton = center_cell_id.y + axis * axis_vector.y
		entity_position = ground_layer.map_to_local(Vector2i(x_position, y_posiiton))
		current_entity = ground_layer.get_entity_at(entity_position)
		if current_entity:
			current_entity.current_health -= damage
			is_successful = true
	
	if is_successful:
		end_turn()
