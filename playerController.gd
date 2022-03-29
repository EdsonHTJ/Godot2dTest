extends Node


var maxLife = 100
var life = maxLife
var isSuffering = false
var damageDirection = 0

var hasBootPu = false
var hasFirePu = false

signal playerHited()
signal playerAttacks(body, damage, direction)

func die():
	life = maxLife
	
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

