extends Node2D
class_name HealthComponent

@export var max_health := 10
var health : float

signal damaged(damage: float)
signal died()

func _ready() -> void:
	health = max_health

func damage(attack: float):
	health -= attack
	damaged.emit(attack)
		
	if health <= 0:
		died.emit()
