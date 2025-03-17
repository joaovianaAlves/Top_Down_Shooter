class_name Bullet
extends CharacterBody2D

@export var hitbox: HitboxComponent

@export var damage: float = 0.5
@export var speed: float = 1000
@export var lifetime: float = 0.2
@onready var timer: Timer = %Timer

func _ready() -> void:
	hitbox.attack = damage
	timer.start(lifetime)

func _physics_process(delta: float) -> void:
	velocity = Vector2(speed, 0).rotated(rotation)
	move_and_slide()
	
	var collision: KinematicCollision2D = get_last_slide_collision()
	if collision:
		var collider: Object = collision.get_collider()
		if collider is Walls:
			queue_free()

func _on_timer_timeout() -> void:
	queue_free()

func _on_hitbox_component_damaging(damage: float) -> void:
	queue_free()
