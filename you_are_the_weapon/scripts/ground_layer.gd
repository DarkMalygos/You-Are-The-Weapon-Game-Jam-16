extends TileMapLayer
class_name GroundLayer

@onready var cell_size: Vector2i = tile_set.tile_size

var astar_grid = AStarGrid2D.new()
var entities: Array[Entity] = []

func _ready() -> void:
	initialize_grid()

func initialize_grid():	
	astar_grid.region = get_used_rect()
	astar_grid.cell_size = cell_size
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar_grid.update()
	
	for x in get_used_rect().size.x:
		for y in get_used_rect().size.y:
			var tile_position = Vector2i(
				x + get_used_rect().position.x,
				y + get_used_rect().position.y
				)
				
			var tile_data = get_cell_tile_data(tile_position)
			if !tile_data || tile_data.get_collision_polygons_count(0) > 0:
				astar_grid.set_point_solid(tile_position)

func get_entity_at(tile_position: Vector2) -> Entity:
	for entity in entities:
		if entity.target_position == tile_position:
			return entity
			
	return null
	
func get_cell_ids_in_range(cell_id: Vector2i, weapon_range: int) -> Array[Vector2i]:
	var cell_ids_in_range: Array[Vector2i] = []
	var x_range: int
	var current_cell_id: Vector2i
	
	for y in range(-weapon_range, weapon_range + 1):
		x_range = weapon_range - abs(y)
		
		for x in range(-x_range, x_range + 1):
			current_cell_id = Vector2i(cell_id.x + x, cell_id.y + y)
			
			if !get_cell_tile_data(current_cell_id):
				continue
				
			if !astar_grid.is_point_solid(current_cell_id):
				cell_ids_in_range.append(current_cell_id)
			
	return cell_ids_in_range

func move_enemies():
	for entity in entities:
		if entity is Enemy:
			if !entity.activate():
				entities.erase(entity)
				entities.append(entity)
