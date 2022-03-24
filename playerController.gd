extends Node


var maxLife = 100
var life = maxLife
var playerHited = false
var isSuffering = false

func attackPlayer(damage):
	life -= damage
	playerHited = true
