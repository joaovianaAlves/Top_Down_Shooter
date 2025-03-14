extends Node2D

@export var health: HealthComponent
var health_bar: ProgressBar

func _ready() -> void:
	if health:
		health.damaged.connect(_on_damaged)
		
		health_bar = ProgressBar.new()
		health_bar.size = Vector2(20, 5)
		health_bar.max_value = health.max_health
		health_bar.value = health.health
		health_bar.top_level = true
		add_child(health_bar)

func _process(delta: float) -> void:
	if health_bar:
		var bar_offset = Vector2(0, -30)
		health_bar.global_position = global_position + Vector2.UP * 40

func _on_damaged(damage: float):
	if health_bar:
		health_bar.value = max(0, health.health)
