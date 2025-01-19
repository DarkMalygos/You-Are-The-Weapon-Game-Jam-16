extends Area2D
class_name Enemy

@onready var ground_layer: TileMapLayer = get_node("../TileMap/GroundLayer")
@onready var cell_size: Vector2i = ground_layer.tile_set.tile_size
@onready var player: Player = get_node("../Player")

var astar_grid = AStarGrid2D.new()

func _ready() -> void:
	initialize_grid()

func initialize_grid():	
	astar_grid.region = ground_layer.get_used_rect()
	astar_grid.cell_size = cell_size
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar_grid.update()
	
	for x in ground_layer.get_used_rect().size.x:
		for y in ground_layer.get_used_rect().size.y:
			var tile_position = Vector2i(
				x + ground_layer.get_used_rect().position.x,
				y + ground_layer.get_used_rect().position.y
				)
				
			var tile_data = ground_layer.get_cell_tile_data(tile_position)
			
			if !tile_data || tile_data.get_collision_polygons_count(0) > 0:
				astar_grid.set_point_solid(tile_position)
	
func move():
	var local_position = ground_layer.to_local(global_position)
	var player_position = ground_layer.to_local(player.global_position)
	
	if !ground_layer.get_used_rect().has_point(ground_layer.local_to_map(player_position)):
		return
		
	var id_path = astar_grid.get_id_path(
		ground_layer.local_to_map(local_position),
		ground_layer.local_to_map(player_position)
	).slice(1)

	if id_path.is_empty():
		return

	global_position = ground_layer.map_to_local(id_path.front())
