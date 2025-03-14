extends Area2D
class_name HitboxComponent

@export var attack: float

signal damaging(damage: float)

func _on_area_entered(area: Area2D):
	if area is HurtboxComponent:
		area.receive_damage(attack)
		damaging.emit(attack)
