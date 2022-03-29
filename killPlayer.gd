extends Area2D




func _on_killPlayer_body_entered(body):
	print(body.name)
	if body.name =="player":
		print("killp")
		PlayerController.killPlayer()
	pass # Replace with function body.

