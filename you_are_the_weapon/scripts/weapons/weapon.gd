extends Control
class_name Weapon

@export var weapon_range: int = 1
@export var damage: int = 1

@onready var ground_layer: GroundLayer = get_node("/root/Game/TileMap/GroundLayer")
@onready var valid_tile_hint_layer: TileMapLayer = get_node("/root/Game/TileMap/ValidTileHintLayer")

var valid_cell_ids: Array[Vector2i] = []

func select(position: Vector2i):
	$ColorRect.color = Color.RED
	show_valid_cells(position)

func deselect():
	$ColorRect.color = Color.WHITE
	hide_valid_cells()

func show_valid_cells(cell_id: Vector2i):
	valid_cell_ids = ground_layer.get_cell_ids_in_range(cell_id, weapon_range)
	for valid_cell_id in valid_cell_ids:
		valid_tile_hint_layer.set_cell(valid_cell_id, 0, Vector2i(2, 0))

func hide_valid_cells():
	for valid_cell_id in valid_cell_ids:
		valid_tile_hint_layer.set_cell(valid_cell_id)
		
	valid_cell_ids.clear()

func activate(target_cell_id: Vector2i):
	if !valid_cell_ids.has(target_cell_id):
		return
		
	var entity: Entity = ground_layer.get_entity_at(ground_layer.map_to_local(target_cell_id))
		
	if !entity:
		return
		
	entity.current_health -= damage
