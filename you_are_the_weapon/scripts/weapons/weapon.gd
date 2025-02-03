extends Control
class_name Weapon

signal weapon_mouse_down(weapon: Weapon)

@export var weapon_range: int = 1
@export var damage: int = 1
@export var weapon_sound: AudioStreamWAV
@export var sprite_name: String = "sword"
@export var max_cooldown: int = 1

@onready var ground_layer: GroundLayer = get_node("/root/Game/TileMap/GroundLayer")
@onready var valid_tile_hint_layer: TileMapLayer = get_node("/root/Game/TileMap/ValidTileHintLayer")
@onready var player: Player = get_node("../../../../..")
@onready var current_cooldown: int = 0:
	set(value):
		var cooldown_value: int = max(0, value)
		current_cooldown = cooldown_value
		$Label.text = str(cooldown_value)

var valid_cell_ids: Array[Vector2i] = []

func _ready() -> void:
	weapon_mouse_down.connect(player.on_weapon_mouse_down)
	$ColorRect.color = Color.SADDLE_BROWN

func select(position: Vector2i):
	$ColorRect.color = Color.DARK_RED
	show_valid_cells(position)

func deselect():
	$ColorRect.color = Color.SADDLE_BROWN
	hide_valid_cells()

func show_valid_cells(cell_id: Vector2i):
	valid_cell_ids = ground_layer.get_cell_ids_diamond(cell_id, weapon_range)
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
		
	current_cooldown = max_cooldown + 1
	entity.current_health -= damage
	end_turn()

func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse"):
		weapon_mouse_down.emit(self)

func end_turn():
	deselect()
	player.selected_weapon = null
	player.current_state = player.States.MOVEMENT
	SoundManager.play_sound(player.get_node("SoundsPlayer"), weapon_sound)
	
	ground_layer.move_enemies()
