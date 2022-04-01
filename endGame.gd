extends Sprite

func _ready():
	$score.text = "Score: " + str(PlayerController.score)
