extends Node2D

func _process(delta):
	$life.value = 100 * PlayerController.life / PlayerController.maxLife
	$Lifes.text = "Lifes: " + str(PlayerController.lifes)
	$Score.text = "Score: " + str(PlayerController.score)
