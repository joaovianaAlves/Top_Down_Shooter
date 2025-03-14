extends Area2D
class_name HurtboxComponent

@export var health_component: HealthComponent

signal damaged(damage: float)

func receive_damage(attack: float):
	if health_component:
		health_component.damage(attack)
	damaged.emit(attack)
