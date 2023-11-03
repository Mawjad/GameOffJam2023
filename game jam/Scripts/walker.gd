extends Node
class_name Walker

const DIRECTIONS = [Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN]

@export var min_width = 2
@export var max_width = 6
@export var min_height = 2
@export var max_height = 6

var position = Vector2.ZERO
var direction = Vector2.RIGHT
var borders = Rect2()
var step_history = []
var steps_since_turn = 0
var rooms = []

func _init(starting_position, new_borders):
	assert(new_borders.has_point(starting_position))
	position = starting_position
	step_history.append(position)
	borders = new_borders

func walk(steps):
	place_room(position)
	for step in steps:
		print("Current Position: ", position)
		if randf() < 0.025:  # 5% chance to change direction
			change_direction()
		if steps_since_turn >= 360:  # Or whatever value you decide on
			change_direction()
		if step():
			step_history.append(position)
			#tileMap.set_cell(position.x, position.y, FLOOR_TILE_ID) possible solution
		if step % 100 == 0:  # Every 100 steps
			var percent_complete = float(step) / steps * 100
			print("Completion: ", percent_complete, "%")
		else:
			change_direction()
	# Final completion statement
	print("Walker has completed its journey. 100% done.")
	return step_history

func step():
	var target_position = position + direction
	if borders.has_point(target_position):
		steps_since_turn += 1
		position = target_position
		return true
	else:
		return false

func change_direction():
	if randf() < 0.001:  # 20% chance to place a room
		place_room(position)
	steps_since_turn = 0
	var directions = DIRECTIONS.duplicate()
	directions.erase(direction)
	directions.shuffle()
	direction = directions.pop_front()
	while not borders.has_point(position + direction):
		direction = directions.pop_front()

func create_room(position, size):
	return {position = position, size = size}

func place_room(position):
	var size = Vector2(randi() % (max_width - min_width + 1) + min_width, randi() % (max_height - min_height + 1) + min_height)
	var top_left_corner = (position - size/2).ceil()
	rooms.append(create_room(position, size))
	for y in size.y:
		for x in size.x:
			var new_step = top_left_corner + Vector2(x, y)
			if borders.has_point(new_step):
				step_history.append(new_step)

func get_end_room():
	var end_room = rooms.pop_front()
	var starting_position = step_history.front()
	for room in rooms:
		if starting_position.distance_to(room.position) > starting_position.distance_to(end_room.position):
			end_room = room
	return end_room
