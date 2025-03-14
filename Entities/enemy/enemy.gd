extends CharacterBody2D

@export var nav_agent: NavigationAgent2D

var player: CharacterBody2D
var speed = 100

func _ready() -> void:
	player = Global.player
	
func _physics_process(delta: float) -> void:
	if player:
		nav_agent.target_position = player.global_position
		var direction = (nav_agent.get_next_path_position() - global_position).normalized()
		velocity = direction * speed
		look_at(player.position)
		move_and_slide()

func killed():
	queue_free()
	
func _on_health_component_died() -> void:
	killed()
