extends Enemy
class_name Boss

func destroy():
	ground_layer.entities.erase(self)
	queue_free()
