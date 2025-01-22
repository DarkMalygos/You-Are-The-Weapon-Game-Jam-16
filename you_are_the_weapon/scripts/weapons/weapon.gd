extends Control
class_name Weapon

var selected: bool = false

func select():
	$ColorRect.color = Color.RED

func deselect():
	$ColorRect.color = Color.WHITE
	
func activate():
	push_error("abstract method")
