extends Area2D

@onready var layer: TileMapLayer = get_node("../TileMap/GroundLayer")
@onready var player: Player = get_node("../Player")

var current_path: Array[Vector2i]

func move():
	var player_position = player.global_position
	current_path = layer.a_star_grid.get_id_path(
		layer.local_to_map(global_position),
		layer.local_to_map(player_position)
	).slice(1)
	if current_path.is_empty():
		return
	var target_position = layer.map_to_local(current_path.front())
	global_position = global_position.move_toward(target_position, 10)
