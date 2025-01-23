extends Weapon
class_name Sword

func show_valid_cells(position: Vector2i):
	print(ground_layer.get_cells_in_range(position, 1))
