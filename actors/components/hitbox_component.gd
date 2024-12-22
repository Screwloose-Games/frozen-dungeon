## Shows the area that the weapon/entity can "hit"
class_name HitBoxComponent
extends Area2D

signal hit(target: Area3D)

func hit_target(target: HurtBoxComponent, damage: int):
    target.receive_hit(damage)
    hit.emit(target)
