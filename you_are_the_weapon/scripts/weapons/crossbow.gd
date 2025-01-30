extends Weapon
class_name  Crossbow

func show_valid_cells(cell_id: Vector2i):
	valid_cell_ids = ground_layer.get_cell_ids_line(cell_id, weapon_range)
	for valid_cell_id in valid_cell_ids:
		valid_tile_hint_layer.set_cell(valid_cell_id, 0, Vector2i(2, 0))
