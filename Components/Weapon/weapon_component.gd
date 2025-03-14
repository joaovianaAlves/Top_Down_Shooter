class_name WeaponComponent
extends Node2D

@export var bullet: PackedScene

@export var bullet_damage: float
@export var bullet_speed: float
@export var bullet_amount: int
@export var bullet_spread: int
@export var fire_delay: float
@export var muzzle: Marker2D

var can_fire: bool = true
var fire_timer: Timer

func _ready():
	fire_timer = Timer.new()
	fire_timer.wait_time = fire_delay
	fire_timer.one_shot = true
	fire_timer.timeout.connect(_on_fire_timer_timeout)
	add_child(fire_timer)

func _on_fire_timer_timeout():
	can_fire = true

func fire(stats_changers: Array[BulletStatUpgrade]):
	if not can_fire:
		return
	
	can_fire = false
	fire_timer.start()
	
	for index in range(bullet_amount):
		var bullet_instance: Bullet = bullet.instantiate()
		bullet_instance.global_position = muzzle.global_position
		
		var fire_direction = (get_global_mouse_position() - muzzle.global_position).normalized()

		var spread_angle = deg_to_rad(randf_range(-bullet_spread / 2, bullet_spread / 2))
		var rotated_direction = fire_direction.rotated(spread_angle)

		bullet_instance.global_rotation = rotated_direction.angle()
		
		bullet_instance.damage = bullet_damage
		bullet_instance.speed = bullet_speed
		
		for stat_upgrade in stats_changers:
			stat_upgrade.apply_upgrade(bullet_instance) 

		get_tree().get_root().call_deferred("add_child", bullet_instance)
