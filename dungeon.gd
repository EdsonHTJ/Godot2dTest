extends Node2D

var borders = Rect2(5, 5, 110, 110)
onready var tilemap = $TileMap

var mushEnemy = load("res://mushromEnemy.tscn")
func _ready():
	generate_level()
	
func generate_level():
	randomize()
	PlayerController.hasBootPu = true
	var n = 3
	var mapBorder = borders
	mapBorder.end = mapBorder.end / n
	var walker = Walker.new(Vector2(5, 5), borders)
	var map = walker.walk(5000)
	walker.queue_free()
	map.sort()
	print("aa")
	for location in map:
		var y = 0
		var x = 0

		while y < n: 
			tilemap.set_cellv(location+ Vector2(x,y), -1)
			x += 1
			if x > n:
				x = 0
				y +=1
	var x = 0
	var y = 0
	var finish = false
	while not finish:
		var exists = tilemap.get_cell(x,y)
		if exists != tilemap.INVALID_CELL:
			"""var upper = tilemap.get_cell(x,y-1)
			var down = tilemap.get_cell(x, y+1)
			
			if upper == tilemap.INVALID_CELL and down == tilemap.INVALID_CELL:
				tilemap.set_cellv(x, y, -1)
			"""
		else:
			var upper = tilemap.get_cell(x,y-1)
			var down = tilemap.get_cell(x, y+1)
			
			if upper == tilemap.INVALID_CELL and down == tilemap.INVALID_CELL:
		
				var r = randf()
				if r < 0.01:
					var spX = x * tilemap.cell_size.x * tilemap.scale.x
					var spY = y * tilemap.cell_size.y * tilemap.scale.y
					var enemy = mushEnemy.instance()
					enemy.position.x = spX
					enemy.position.y = spY
					add_child(enemy)
					print("add enemy")
		
		x+=1
		if x >= 50:
			y +=1
			x = 0
		if y >= 50:
			finish = true
				
	tilemap.update_bitmask_region(borders.position, borders.end + Vector2(20,20))
