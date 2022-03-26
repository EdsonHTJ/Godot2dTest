extends Area2D

var direction = -1

func _physics_process(delta):
	for body in get_overlapping_bodies():
		if body.name == "player":
			PlayerController.hasBootPu = true
			queue_free()
	
	position.y += direction * 0.5



func _on_Timer_timeout():
	direction *= -1
	pass # Replace with function body.
