extends Node


var maxLife = 100
var life = maxLife
var lifes = 3
var isSuffering = false
var damageDirection = 0
var score = 0
var hasBootPu = true
var hasFirePu = false

var playerDamage = 60
var speedx = 200
var jumpForce = 600
var lastDoorPos = 0

var lastPos = Vector2(600, 600)

signal playerHited()
signal playerAttacks(body, damage, direction)

func die():
	life = maxLife
	lifes -=1
	score -= 20
	if lifes < 0:
		lifes = 3
		gameOver()
	
func killPlayer():
	life = -1
	emit_signal("playerHited")

func attackPlayer(damage, direction):
	if isSuffering:
		return
		
	life -= damage
	damageDirection = direction
	emit_signal("playerHited")
	print(direction)
	
func playerAttacks(damage, body, direction):
	emit_signal("playerAttacks", damage, body, direction)
	
func gameOver():
	life = maxLife
	lifes = 3
	#score = 0
	hasBootPu = false
	hasFirePu = false
	get_tree().change_scene("res://endGame.tscn")
	pass

