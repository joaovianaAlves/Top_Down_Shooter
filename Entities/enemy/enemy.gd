extends CharacterBody2D

@export var nav_agent: NavigationAgent2D

var player: CharacterBody2D
var speed = 100

@export var directional_blood: PackedScene

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
	var directional_blood_instance = directional_blood.instantiate() as CPUParticles2D
	get_tree().root.add_child(directional_blood_instance)
	directional_blood_instance.global_position = global_position
	directional_blood_instance.look_at(Global.player.global_position)
	
	queue_free()
	
func _on_health_component_died() -> void:
	killed()
