class_name Player
extends CharacterBody2D

@export var move_speed: float
@export var gun: WeaponComponent

@export var pistol: Pistol
@export var shotgun: Shotgun

var cursor1 = preload("res://Art/New Piskel (8).png")
var cursor2 = preload("res://Art/New Piskel (7).png")

var stats_changers: Array[BulletStatUpgrade] = []

func _enter_tree() -> void:
	Global.player = self

func _ready() -> void:
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		Input.set_custom_mouse_cursor(cursor2)
	else:
		Input.set_custom_mouse_cursor(cursor1)
		

func get_input():
	var input_dir = Input.get_vector("A","D","W","S")
	velocity = input_dir * move_speed

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Shoot"):
		gun.fire(stats_changers)
		
	if Input.is_action_just_pressed("R"):
		gun.reload()

	if Input.is_action_just_pressed("ScrollUp"):
		pistol.hide()
		shotgun.show()
		gun = shotgun
	if Input.is_action_just_pressed("ScrollDown"):
		shotgun.hide()
		pistol.show()
		gun = pistol
		
	get_input()
	move_and_slide()
	look_at(get_global_mouse_position())


func killed():
	get_tree().reload_current_scene()


func _on_health_component_died() -> void:
	killed()
