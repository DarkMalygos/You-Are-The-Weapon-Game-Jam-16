extends Enemy
class_name WoodCutter

func _ready() -> void:
	packed_weapon = preload("res://scenes/weapons/sword.tscn")
	
	super._ready()
