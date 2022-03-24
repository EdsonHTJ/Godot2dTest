extends Node


var maxLife = 100
var life = maxLife
var isSuffering = false
var damageDirection = 0

signal playerHited()
signal playerAttacks(body, damage)

func attackPlayer(damage, direction):
	if isSuffering:
		return
		
	life -= damage
	damageDirection = direction
	emit_signal("playerHited")
	print(direction)
	
func playerAttacks(damage, body):
	emit_signal("playerAttacks", damage, body)

