class_name EnemyChaseState
extends State

@export var navigation_agent: NavigationAgent2D
@export var actor: Enemy
@export var vision_cast: RayCast2D
@export var velocity_component: Node

signal lost_player

func _ready() -> void:
	set_physics_process(false)

func _enter_state() -> void:
	set_physics_process(true)

func _exit_state() -> void:
	set_physics_process(false)

func _physics_process(delta) -> void:
	var next_point = actor.to_local(actor.navigation_agent.get_next_path_position()).normalized()
	velocity_component.accelerate_in_direction(next_point)
	velocity_component.move_with_collision(actor, delta)
	
	if not vision_cast.is_colliding():
		lost_player.emit()
