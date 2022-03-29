extends Area2D


func _on_nextLevel_body_entered(body):
	print(body.name)
	if body.name =="player":
		print("changing level")
		get_tree().change_scene("res://level2.tscn")
	pass # Replace with function body.
