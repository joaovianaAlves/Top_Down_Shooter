extends Label

func _ready() -> void:
	Global.player_ammo_changed.connect(update_ammo_display)

func update_ammo_display(ammo: int, max_ammo:int) -> void:
	text = str(ammo) + "/" + str(max_ammo)
