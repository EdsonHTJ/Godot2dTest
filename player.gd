extends KinematicBody2D


var speedx = 200
var movement = Vector2(0,0)
var G = 2*  9.81
const jumpForce = 700
var isAttacking = false
var atkDirection = 0
var initial = Vector2(0,0)
var playerDamage = 60
var maxVely = 500
var djReady = true
var onDeath = false

var espMov = Vector2(0,0)
var atkBtn = 0
var jumpBtn = 0
var isJumpingFlg = false
var isAtkFlg = false

const ESP=true;

func _ready():
	PlayerController.connect("playerHited", self, "_on_player_hitted")

	Socket.connect("setUserState", self, "_setUserState")
	initial = position

func _setUserState(x, y, b1, b2):
	if x != 0xff:
		espMov.x = x
		espMov.y = y
	print("Isjmp ", b1)
	if (true):
		isJumpingFlg = b1
	if(true):
		isAtkFlg = b2
	pass
	
func _physics_process(delta):
	var movx	
	if not ESP:		
		movx = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	else:
		movx = (espMov.x)
		if abs(movx) < 0:
			movx = 0
		movx = movx 
		
	if PlayerController.isSuffering:
		movx = -1 * PlayerController.damageDirection
		$AnimatedSprite.flip_h = (PlayerController.damageDirection != 1)
	movement.x = movx * speedx
	
	if(is_on_ceiling()):
		movement.y = 0
		
	if(not is_on_floor()):
		movement.y += G
		if movement.y > maxVely:
			movement.y = maxVely
	else:
		if not djReady:
			djReady = true
			#Socket.write_text("l1")

	var jump 
	if  !ESP:
		jump = Input.is_action_just_pressed("jump")
	else:
		jump = isJumpingFlg
	isJumpingFlg = false
	if jump and (is_on_floor() or _is_dj_enabled()):
		if (not is_on_floor()):
			djReady = false
			#Socket.write_text("l0")
		movement.y = -jumpForce
		
	move_and_slide(movement, Vector2.UP)
	

func _process(delta):
	if PlayerController.life < 0 and not onDeath:
		onDeath = true
		Socket.write_text("l1")
		$AnimatedSprite.play("death")
		
	if PlayerController.isSuffering:
		return 
		
	$attackLeft.get_node("CollisionShape2D").disabled =  not ($AnimatedSprite.flip_h and isAttacking)
	$attackRight.get_node("CollisionShape2D").disabled = not (not $AnimatedSprite.flip_h and isAttacking)
		
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
		
		var isAtk
		if not ESP:
			isAtk = Input.is_action_just_pressed("attack")
		else:
			isAtk = isAtkFlg
			
		isAtkFlg = false
		if isAtk:
			isAttacking = true
			atkDirection = 1 if ($AnimatedSprite.flip_h == false) else -1
			$AnimatedSprite.play("attack")
		
func _is_dj_enabled():
	return djReady and PlayerController.hasBootPu

func _on_player_hitted():
	PlayerController.isSuffering = true
	$AnimatedSprite.play("damage")
	return
	

func _on_AnimatedSprite_animation_finished():
	if onDeath:
		onDeath = false
		_die()
	
	if isAttacking:
		isAttacking = false
	
	if PlayerController.isSuffering:
		PlayerController.isSuffering = false



func _on_attackRight_body_entered(body):
	print(body.name)
	PlayerController.playerAttacks(playerDamage, body, atkDirection)



func _on_attackLeft_body_entered(body):
	PlayerController.playerAttacks(playerDamage, body, atkDirection)


func _die():
	Socket.write_text("l0")
	PlayerController.die()
	position = initial
