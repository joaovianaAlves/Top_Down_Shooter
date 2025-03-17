extends Node2D

@export var health: HealthComponent
var health_bar: TextureProgressBar

func _ready() -> void:
	if health:
		health.damaged.connect(_on_damaged)
		
		health_bar = TextureProgressBar.new()
		health_bar.size = Vector2(40, 8)
		health_bar.max_value = health.max_health
		health_bar.value = health.health
		health_bar.top_level = true
		
		# Assign textures
		health_bar.texture_under = load("res://ui/health_bar_bg.png")
		health_bar.texture_progress = load("res://ui/health_bar_fill.png")
		health_bar.texture_over = load("res://ui/health_bar_border.png")

		add_child(health_bar)

func _process(delta: float) -> void:
	if health_bar:
		health_bar.global_position = global_position + Vector2(0, -30)

func _on_damaged(damage: float):
	if health_bar:
		health_bar.value = max(0, health.health)
