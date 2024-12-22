extends Node2D

@export var damage: int = 1

@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D
@onready var attack_animated_sprite_2d: AnimatedSprite2D = %AttackAnimatedSprite2D
@onready var attack_area_2d: Area2D = %AttackArea2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  if Input.is_action_just_pressed("attack"):
    blow_fire()


func blow_fire():
  #var translation = Vector2(24, -20) 
  animated_sprite_2d.play.call_deferred("fire")
  var local_fire: AnimatedSprite2D = attack_animated_sprite_2d.duplicate()
  #attack_animated_sprite_2d.play("fire")
  #local_fire.top_level = true
  attack_animated_sprite_2d.add_sibling(local_fire)
  local_fire.set_global_transform(attack_animated_sprite_2d.global_transform)
  local_fire.set_global_position(attack_animated_sprite_2d.global_position)
  local_fire.play.call_deferred("fire")
  local_fire.set_visible.call_deferred(true)
  var overlapping_hurt_boxes = attack_area_2d.get_overlapping_areas()
  for area in overlapping_hurt_boxes:
    if area is HurtBoxComponent:
      (area as HurtBoxComponent).receive_hit(damage)
    
  await local_fire.animation_finished
  local_fire.queue_free.call_deferred()
