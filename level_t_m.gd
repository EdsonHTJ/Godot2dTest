extends Node2D

func _ready():
	_player_pos()

		

func _player_pos():
	if PlayerController.lastDoorPos == 1:
		$player.position = Vector2(1214,420)
	elif PlayerController.lastDoorPos == 2:
		$player.position = Vector2(PlayerController.lastPos.x,605)
		$player.isJumpingFlg = true;
	elif PlayerController.lastDoorPos == 3:
		$player.position = Vector2(150,434)
	else:
		$player.position = Vector2(PlayerController.lastPos.x,41)	

