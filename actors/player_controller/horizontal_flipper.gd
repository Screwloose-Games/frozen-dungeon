extends Node
class_name HorizontalFlipper

@export var translation_base: CharacterBody2D
@export var translation_target: Node2D

var right_val: int = 1

func _process(delta):
    if is_moving_left():
        _face_left()
    elif is_moving_right():
        _face_right()

func is_moving_left():
    return translation_base.velocity.x < 0

func is_moving_right():
    return translation_base.velocity.x > 0

func _is_facing_left():
    return translation_target.global_transform.x.x == -right_val

func _face_left():
    translation_target.global_transform.x.x = -right_val

func _face_right():
    translation_target.global_transform.x.x = right_val
