extends Node2D

var enemy = preload("res://Entities/enemy/Enemy.tscn")
var spawn_points: Array[Marker2D] = []
var min_player_distance = 100

@export var player: CharacterBody2D

func _ready() -> void:
	$Timer.start()
	for i in get_children():
		if i is Marker2D:
			spawn_points.append(i)

func _on_timer_timeout() -> void:
	var enemies = get_tree().get_nodes_in_group("enemies")
	if enemies.size() <= 10:
		var spawn_pos: Marker2D = spawn_points[randi() % spawn_points.size()]
		if player.global_position.distance_to(spawn_pos.global_position) < min_player_distance:
			return _on_timer_timeout()
		var en = enemy.instantiate()
		en.global_position = spawn_pos.global_position
		get_parent().add_child(en)
		en.add_to_group("enemies")
	
