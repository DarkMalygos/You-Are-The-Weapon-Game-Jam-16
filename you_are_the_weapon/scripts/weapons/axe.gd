extends Weapon
class_name Axe

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
	
	for axis in range(-1, 2):
		entity_position = ground_layer.map_to_local(Vector2i(center_cell_id.x + axis * axis_vector.x, center_cell_id.y + axis * axis_vector.y))
		current_entity = ground_layer.get_entity_at(entity_position)
		if current_entity:
			current_entity.current_health -= damage
			deselect()
			player.selected_weapon = null
			player.current_state = player.States.MOVEMENT
			SoundManager.play_sound(player.get_node("SoundsPlayer"), weapon_sound)
			
			ground_layer.move_enemies()
			
