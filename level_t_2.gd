extends Node2D

func _ready():
	_player_pos()
	
func _player_pos():
	if PlayerController.lastDoorPos == 1:
		$player.position = Vector2(1214,420)
	else:
		$player.position = Vector2(150,434)



