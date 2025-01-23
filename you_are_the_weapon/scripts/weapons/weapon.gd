extends Control
class_name Weapon

@export var weapon_range: int = 1

@onready var ground_layer: GroundLayer = get_node("/root/Game/TileMap/GroundLayer")

var selected: bool = false

func select(position: Vector2i):
	$ColorRect.color = Color.RED
	show_valid_cells(position)

func deselect():
	$ColorRect.color = Color.WHITE

func activate():
	push_error("abstract method")

func show_valid_cells(position: Vector2i):
	push_error("abstract method")
