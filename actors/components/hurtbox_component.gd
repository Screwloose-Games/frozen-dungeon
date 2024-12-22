## Shows the area in which the entity can be hurt
extends Area2D
class_name HurtBoxComponent

signal hurt(damage: int)

@onready var health_component: HealthComponent = %HealthComponent

func receive_hit(damage: int):
  hurt.emit(damage)
  health_component.take_damage(damage)
