extends TileMapLayer
class_name GroundLayer

@onready var cell_size: Vector2i = tile_set.tile_size
@onready var player: Player = $"../../Player"
@onready var obstacle_layer: TileMapLayer = $"../ObstacleLayer"

var astar_grid = AStarGrid2D.new()
var entities: Array[Entity] = []

func _ready() -> void:
	create_boundary_tiles(1)
	initialize_astar_grid()

func create_boundary_tiles(radius: int):
	var used_cells = get_used_cells()
	
	for used_cell in used_cells:
		for x in range(-radius, radius + 1):  # Vízszintesen a sugár mentén
			for y in range(-radius, radius + 1):  # Függőlegesen a sugár mentén
				if x != 0 or y != 0:  # Nem kell felülírni az aktuális csempét
					create_boundary_tile(used_cell + Vector2i(x, y))
		
func initialize_astar_grid():	
	astar_grid.region = get_used_rect()
	astar_grid.cell_size = cell_size
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar_grid.update()
	
	var tile_position: Vector2i
	var tile_data: TileData
	var obstacle_tile_data: TileData
	
	for x in get_used_rect().size.x:
		for y in get_used_rect().size.y:
			tile_position = Vector2i(
				x + get_used_rect().position.x,
				y + get_used_rect().position.y
				)
				
			tile_data = get_cell_tile_data(tile_position)
			
			if !tile_data || tile_data.get_collision_polygons_count(0) > 0:
				astar_grid.set_point_solid(tile_position)
			
			obstacle_tile_data = obstacle_layer.get_cell_tile_data(tile_position)
			
			if obstacle_tile_data:
				if obstacle_tile_data.get_collision_polygons_count(0) > 0:
					astar_grid.set_point_solid(tile_position)
		
func create_boundary_tile(cell: Vector2i):
		if not get_cell_tile_data(cell):
			set_cell(cell, 4, Vector2i(0, 0))

func get_entity_at(tile_position: Vector2) -> Entity:
	for entity in entities:
		if entity.target_position == tile_position:
			return entity
			
	return null
	
func get_cell_ids_diamond(center_cell_id: Vector2i, weapon_range: int) -> Array[Vector2i]:
	var cell_ids_in_range: Array[Vector2i] = []
	var x_range: int
	var current_cell_id: Vector2i
	
	for y in range(-weapon_range, weapon_range + 1):
		x_range = weapon_range - abs(y)
		
		for x in range(-x_range, x_range + 1):
			current_cell_id = Vector2i(center_cell_id.x + x, center_cell_id.y + y)
			
			if is_cell_valid(current_cell_id, center_cell_id):
				cell_ids_in_range.append(current_cell_id)
			
	return cell_ids_in_range

func get_cell_ids_diagonal(center_cell_id: Vector2i, weapon_range: int) -> Array[Vector2i]:
	var cell_ids_in_range: Array[Vector2i]
	var current_cell_id: Vector2i
	var distance: int
	
	for current_range in range(weapon_range, 0, -1):
		distance = current_range * 2
		for y in range(-current_range, current_range + 1, distance):
			for x in range(-current_range, current_range + 1, distance):
				current_cell_id = Vector2i(center_cell_id.x + x, center_cell_id.y + y)
		
				if is_cell_valid(current_cell_id, center_cell_id):
					cell_ids_in_range.append(current_cell_id)
			
	return cell_ids_in_range

func get_cell_ids_line(center_cell_id: Vector2i, weapon_range: int) -> Array[Vector2i]:
	var cell_ids_in_range: Array[Vector2i]
	var current_cell_id: Vector2i
	var axis_vector: Vector2i = Vector2i(1, 0)
	
	for i in range(2):
		for axis in range(-weapon_range, weapon_range + 1):
			current_cell_id = Vector2i(center_cell_id.x + axis * axis_vector.x, center_cell_id.y + axis * axis_vector.y)
			
			if is_cell_valid(current_cell_id, center_cell_id):
				cell_ids_in_range.append(current_cell_id)
				
		axis_vector = Vector2i(0, 1)
				
	return cell_ids_in_range

func is_cell_valid(cell_id: Vector2i, center_cell_id: Vector2i) -> bool:		
	if !get_cell_tile_data(cell_id) || center_cell_id == cell_id:
		return false
		
	if astar_grid.is_point_solid(cell_id):
		return false
		
	return true

func move_enemies():
	player.update_weapon_cooldowns()
	
	for entity in entities:
		if entity is Enemy:
			if !entity.activate():
				entities.erase(entity)
				entities.append(entity)
