extends KinematicBody2D


var speedx = 200
var movement = Vector2(0,0)
var G = 9.81
const jumpForce = 500
var isAttacking = false
var initial = Vector2(0,0)
var maxLife = 100
var life = maxLife
var onDeath = false
var walkdir = -1
var foundPlayer = false
var player = null
signal attack(body)

func _ready():
	$hit.get_node("CollisionShape2D").disabled = true
	PlayerController.connect("playerAttacks", self, "_on_damage")
	initial = position

func _physics_process(delta):
	if not isAttacking:
		if onDeath:
			$hit.get_node("CollisionShape2D").disabled = true
			return
		
		if foundPlayer:	
			var movx = speedx * position.direction_to(player.position).x
			movement.x = movx
			movement.y += G
			move_and_slide(movement, Vector2.UP)

		$hit.get_node("CollisionShape2D").disabled = true
	else:
		$hit.get_node("CollisionShape2D").disabled = false

func _process(delta):
	$ProgressBar.value = 100 * life / maxLife
	if movement.x < 0:
		$AnimatedSprite.flip_h = true
		$hit.scale.x = 1
	elif movement.x > 0:
		$AnimatedSprite.flip_h = false
		$hit.scale.x = -1

func _attack():
	if not onDeath:
		isAttacking = true	
		$AnimatedSprite.play("attack")

func _on_Timer_timeout():
	_attack()
	pass # Replace with function body.


func _on_hit_body_entered(body):
	if body.name == "player":
		var posDif = position.x - body.position.x
		print(position.x)
		print(body.position.x)
		print(posDif)
		posDif = posDif / abs(posDif)
		PlayerController.attackPlayer(30, posDif)
	pass # Replace with function body.
	


func _on_damage(damage, body, direction):
	if body.name == name:
		life -= damage
		if life < 0:
			$AnimatedSprite.play("death")
			onDeath = true
			


func _on_AnimatedSprite_animation_finished():
	if isAttacking:
		isAttacking = false
		$AnimatedSprite.play("default") 
	else:
		if onDeath:
			queue_free()
	pass # Replace with function body.


func _on_detectRadius_body_entered(body):
	if body.name == "player":
		player = body
		foundPlayer = true
		
	pass # Replace with function body.
