class_name EnemyWanderState
extends State

@export var actor: Enemy
@export var vision_cast: RayCast2D
@export var velocity_component: Node

var wander_timer: Timer

signal found_player

func _ready():
	set_physics_process(false)
	wander_timer = Timer.new()
	add_child(wander_timer)
	wander_timer.set_one_shot(false)
	wander_timer.set_wait_time(4.0) # Change direction every 4 seconds
	wander_timer.start()
	var callable = Callable(self, "_on_WanderTimer_timeout")
	wander_timer.connect("timeout", callable)
	
func _enter_state() -> void:
	set_physics_process(true)
	if velocity_component.velocity == Vector2.ZERO:
		velocity_component.velocity = Vector2.RIGHT.rotated(randf_range(0, TAU)) * velocity_component.max_speed/2.0

func _exit_state() -> void:
	set_physics_process(false)

func _physics_process(delta):
	velocity_component.move_with_collision(actor, delta)
	if vision_cast.is_colliding():
		found_player.emit()

func _on_WanderTimer_timeout():
	# Generate a random direction
	var random_direction = Vector2(randf() - 0.5, randf() - 0.5).normalized()
	velocity_component.velocity = random_direction * velocity_component.max_speed/2.0
