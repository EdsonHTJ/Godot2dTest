extends Area2D

export var nextLevel = ""
export var customLevel = false
export var randomLevel = false
export var cornerCode = 0

var levelUp = ["res://level_t_4.tscn"]
var levelLeft = ["res://level_t_4.tscn", "res://level_t_2.tscn", "res://level_t_3.tscn"]
var levelRight = ["res://level_t_4.tscn", "res://level_t_2.tscn", "res://level_t_3.tscn","res://level_t_m.tscn"]
var levelDown = ["res://level_t_4.tscn","res://level_t_3.tscn", "res://level_t_m.tscn"]

func _on_nextLevel_body_entered(body):
	print(body.name)
	if body.name =="player":
		PlayerController.isSuffering = false
		_level_change()
	pass # Replace with function body.

func _level_change():
	if randomLevel:
		_random_level_change()
		return
		
	if customLevel:
		_custom_level_change()
		return
	
	_default_level_change()
		
func _random_level_change():
	var nx = ""
	PlayerController.lastDoorPos = cornerCode
	if cornerCode == 1:
		levelLeft.shuffle()
		nx = levelLeft[0]
	elif cornerCode == 2:
		levelUp.shuffle()
		nx = levelUp[0]
	elif cornerCode == 3:
		levelRight.shuffle()
		nx = levelRight[0]
	else:
		levelDown.shuffle()
		nx = levelDown[0]
	
	get_tree().change_scene(nx)
		
		
	
func _custom_level_change():
	print("changing custom level")
	get_tree().change_scene(nextLevel)

func _default_level_change():
	print("changing level")
	get_tree().change_scene("res://level2.tscn")
