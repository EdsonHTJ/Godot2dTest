extends Area2D

var direction = -1

signal picked()

func _physics_process(delta):
	for body in get_overlapping_bodies():
		if body.name == "player":
			PlayerController.hasBootPu = true
			PlayerController.jumpForce += 50
			emit_signal("picked")
			queue_free()
	
	position.y += direction * 0.2



func _on_Timer_timeout():
	direction *= -1
	pass # Replace with function body.
