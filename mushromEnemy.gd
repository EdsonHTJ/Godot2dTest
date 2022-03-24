extends KinematicBody2D


var speedx = 200
var movement = Vector2(0,0)
var G = 9.81
const jumpForce = 500
var isAttacking = false
var initial = Vector2(0,0)
var life = 100

var walkdir = -1
signal attack(body)

func _ready():
	initial = position

func _physics_process(delta):
	var movx = speedx * walkdir
	movement.x = movx
	movement.y += G
	move_and_slide(movement, Vector2.UP)
	pass

func _process(delta):
	if movement.x < 0:
		$AnimatedSprite.flip_h = true
	elif movement.x > 0:
		$AnimatedSprite.flip_h = false



func _on_Timer_timeout():
	walkdir *= -1
	pass # Replace with function body.


func _on_hit_body_entered(body):
	if body.name == "player":
		PlayerController.attackPlayer(10)
	pass # Replace with function body.
