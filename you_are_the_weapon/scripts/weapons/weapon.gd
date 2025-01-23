extends Control
class_name Weapon

@onready var dagger = preload("res://assets/sounds/dagger_player.wav")

var selected: bool = false

func select():
	$ColorRect.color = Color.RED

func deselect():
	$ColorRect.color = Color.WHITE

func activate():
	push_error("abstract method")
