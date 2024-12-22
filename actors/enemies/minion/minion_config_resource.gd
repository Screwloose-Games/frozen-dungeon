extends Resource

class_name MinionConfigResource

@export var speed: float = 45.0
@export var max_health: float = 1.0

func _init(init_speed: float = speed, init_max_health: int = max_health) -> void:
    speed = init_speed
    max_health = init_max_health
