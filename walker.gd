extends Node
class_name Walker

const DIRECTIONS = [Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN]

var position = Vector2.ZERO
var direction = Vector2.RIGHT
var borders = Rect2()

var step_history = []
var steps_since_turn = 0
var noise = OpenSimplexNoise.new()

func _init(starting_position, new_borders):
	noise.seed = randi()
	noise.octaves = 4
	noise.period = 20.0
	noise.persistence = 0.8
	assert(new_borders.has_point(starting_position))
	position = starting_position
	step_history.append(position)
	borders = new_borders

func walk(steps):
	for step in steps:
		var step_limit = 5
		if direction == Vector2.UP or direction == Vector2.DOWN:
			step_limit = 2
		if randi() <= 0.20 or steps_since_turn > step_limit:
			change_directions()
		
		if step():
			step_history.append(position)
		else:
			change_directions()
		
	return step_history
	
func step():
	var target_position = position + direction
	if borders.has_point(target_position):
		steps_since_turn += 1
		position = target_position
		return true
	else:
		return false
	
func change_directions():
	steps_since_turn = 0
	var directions = DIRECTIONS.duplicate()
	directions.erase(direction)
	directions.shuffle()
	var rand = randf()
	
	if rand < 0.40:
		direction = Vector2.RIGHT
	elif rand < 0.75:
		direction = Vector2.LEFT
	elif rand < 0.90:
		direction = Vector2.UP
	else:
		direction = Vector2.DOWN

	while not borders.has_point(position + direction):
		direction = directions.pop_front()
