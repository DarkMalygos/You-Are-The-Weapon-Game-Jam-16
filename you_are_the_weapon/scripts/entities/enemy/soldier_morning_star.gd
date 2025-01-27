extends Enemy
class_name SoldierMorningStar

func _ready() -> void:
	packed_weapon = preload("res://scenes/weapons/chain_morning_star.tscn")
	
	super._ready()
