extends Node2D
class_name DamageIndicator

@export var hurtbox_component: HurtboxComponent

func _ready() -> void:
	hurtbox_component.damaged.connect(_on_damaged)

func _on_damaged(damage: float):
	var label: Label = Label.new()
	var tween: Tween = get_tree().create_tween()
	label.scale = Vector2.ZERO
	label.text = str(damage)
	label.top_level = true
	label.global_position = global_position
	get_tree().root.add_child(label)
	tween.tween_property(label, "scale", Vector2.ONE, 0.2).set_ease(Tween.EASE_OUT)
	tween.tween_property(label,"global_position", Vector2(0,-10), 1).as_relative().finished.connect(label.queue_free)
