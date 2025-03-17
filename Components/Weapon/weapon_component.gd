class_name WeaponComponent
extends Node2D

@export var bullet: PackedScene
@export var shell: PackedScene

@export var bullet_damage: float
@export var bullet_speed: float
@export var bullet_amount: int
@export var bullet_spread: int
@export var fire_delay: float
@export var reload_delay: float
@export var muzzle: Marker2D
@export var shell_drop_position: Marker2D
@export var weapon_sound: AudioStream
@export var weapon_reload_sound: AudioStream
@export var max_ammo: int
@export var reload_on_finish: bool

var reload_gun_audio_player: AudioStreamPlayer
var empty_gun_audio_player: AudioStreamPlayer 
var empty_gun_sound := preload("res://Art/Sounds/empty_gun_sound.wav")
var can_fire: bool = true
var fire_timer: Timer
var gun_audio_player: AudioStreamPlayer 
var ammo := max_ammo
var is_reloading: bool = false
var reload_timer: Timer
var add_bullet_on_reload_timer: Timer

func _ready():
	ammo = max_ammo

	fire_timer = Timer.new()
	fire_timer.wait_time = fire_delay
	fire_timer.one_shot = true
	fire_timer.timeout.connect(_on_fire_timer_timeout)
	add_child(fire_timer)

	add_bullet_on_reload_timer = Timer.new()
	add_bullet_on_reload_timer.one_shot = false
	add_bullet_on_reload_timer.wait_time = reload_delay / max_ammo
	add_bullet_on_reload_timer.timeout.connect(_on_add_reload_timer_timeout)
	add_child(add_bullet_on_reload_timer)
	
	reload_timer = Timer.new()
	reload_timer.wait_time = reload_delay
	reload_timer.one_shot = true
	reload_timer.timeout.connect(_on_reload_timer_timeout)
	add_child(reload_timer)

	reload_gun_audio_player = AudioStreamPlayer.new()
	reload_gun_audio_player.stream = weapon_reload_sound
	reload_gun_audio_player.volume_db = -10
	add_child(reload_gun_audio_player)
	
	empty_gun_audio_player = AudioStreamPlayer.new()
	empty_gun_audio_player.stream = empty_gun_sound
	empty_gun_audio_player.volume_db = -10
	add_child(empty_gun_audio_player)
	
	gun_audio_player = AudioStreamPlayer.new()
	gun_audio_player.stream = weapon_sound
	gun_audio_player.volume_db = -10
	add_child(gun_audio_player)
	Global.player_ammo_changed.emit(ammo, max_ammo)

func _on_fire_timer_timeout():
	can_fire = true
	
func reload():
	if is_reloading or ammo == max_ammo:
		return
	is_reloading = true
	
	if weapon_reload_sound:
		reload_gun_audio_player.play()
	
	if reload_on_finish:
		can_fire = false
		reload_timer.start()
	else:
		add_bullet_on_reload_timer.start()

func _on_reload_timer_timeout():
	ammo = max_ammo
	is_reloading = false
	can_fire = true
	Global.player_ammo_changed.emit(ammo, max_ammo)
	
func _on_add_reload_timer_timeout():
	ammo += 1
	if ammo == max_ammo:
		add_bullet_on_reload_timer.stop()
		is_reloading = false
		reload_gun_audio_player.stop()
	
	Global.player_ammo_changed.emit(ammo, max_ammo)

func fire(stats_changers: Array[BulletStatUpgrade]):
	if ammo <= 0:
		empty_gun_audio_player.play()
		return
	if not can_fire:
		return
	
	if is_reloading:
		if reload_on_finish:
			return
		
		add_bullet_on_reload_timer.stop()
		is_reloading = false
		reload_gun_audio_player.stop()

	can_fire = false
	fire_timer.start()
	
	ammo -= 1
	Global.player_ammo_changed.emit(ammo, max_ammo)

	var shell_instance := shell.instantiate() as Node2D
	shell_instance.top_level = true
	shell_instance.rotate(randf_range(0, TAU))
	shell_instance.global_position = shell_drop_position.global_position - Vector2(0, 10)
	get_tree().root.add_child(shell_instance)
	
	var eject_direction = Vector2(randf_range(-1, 1), randf_range(-1, -0.5)).normalized()
	var eject_distance = randf_range(20, 40)
	var eject_time = 0.1
	var tween = get_tree().create_tween()
	tween.tween_property(shell_instance, "global_position", shell_instance.global_position + (eject_direction * eject_distance), eject_time).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(shell_instance, "rotation_degrees", shell_instance.rotation_degrees + randf_range(90, 180), eject_time).set_trans(Tween.TRANS_LINEAR)

	if weapon_sound and gun_audio_player:
		gun_audio_player.play()

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
