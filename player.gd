extends KinematicBody2D


var speedx = 200
var movement = Vector2(0,0)
var G = 9.81
const jumpForce = 500
var isAttacking = false
var isSufferingDamage = false
var atkDirection = 0
var initial = Vector2(0,0)

signal attack(body)

func _ready():
	initial = position

func _physics_process(delta):
	
	var movx = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	if isSufferingDamage:
		movx = (1000 * 1 if ($AnimatedSprite.flip_h) else -1)
	movement.x = movx * speedx
	
	if(not is_on_floor()):
		movement.y += G

	var jump = Input.get_action_strength("jump")
	if jump and is_on_floor():
		movement.y = -jumpForce
	move_and_slide(movement, Vector2.UP)
	

func _process(delta):
	if isSufferingDamage:
		return 
		
	if PlayerController.playerHited:
		PlayerController.playerHited = false
		isSufferingDamage = true
		$AnimatedSprite.play("damage")
		return
	
	if not isAttacking:
		if(not is_on_floor()):
			if movement.y < 0:
				$AnimatedSprite.play("jump")
			elif movement.y > 0:
				$AnimatedSprite.play("fall")
		else:
			if movement.x != 0:
				$AnimatedSprite.play("run")
			else:
				$AnimatedSprite.play("idle")
				
		if movement.x < 0:
			$AnimatedSprite.flip_h = true
		elif movement.x > 0:
			$AnimatedSprite.flip_h = false
		
		if Input.is_action_just_pressed("attack"):
			isAttacking = true
			atkDirection = 1 if ($AnimatedSprite.flip_h == false) else -1
			$AnimatedSprite.play("attack")
		



func _on_AnimatedSprite_animation_finished():
	if isAttacking:
		isAttacking = false
	elif isSufferingDamage:
		isSufferingDamage = false



func _on_attackRight_body_entered(body):
	if isAttacking and atkDirection == 1:
		emit_signal("attack", body)



func _on_attackLeft_body_entered(body):
	if isAttacking and atkDirection == -1:
		emit_signal("attack", body)




func _on_VisibilityNotifier2D_screen_exited():
	position = initial
	
