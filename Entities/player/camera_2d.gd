extends Camera2D

@onready var phantom_camera = $"../PhantomCamera"
@export var magnitude := 10.0

var is_shaking := false
var shake_amt := Vector2.ZERO

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Shoot"):is_shaking = !is_shaking
	
	if !is_shaking: return
	
	shake_amt = Vae
