class_name UpgradePickup 
extends Node2D

@export var bullet_upgrade: BulletStatUpgrade

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is HurtboxComponent:
		if area.owner is Player:
			(area.owner as Player).stats_changers.append(bullet_upgrade)
			print((area.owner as Player).stats_changers)
	queue_free()
