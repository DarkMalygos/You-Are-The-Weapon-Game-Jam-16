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

func is_cell_empty(tile_position: Vector2) -> bool:
	for entity in entities:
		if entity.global_position == tile_position:
			return false
			
	return true

func move_enemies():
	for entity in entities:
		if entity is Enemy:
			if !entity.activate():
				entities.erase(entity)
				entities.append(entity)
