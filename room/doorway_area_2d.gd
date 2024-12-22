@tool
extends Area2D
class_name Doorway


@export var is_open: bool = false:
  set(val):
    if val == is_open:
      return
    if not is_node_ready():
      return
    if val:
      await open_door()
    else:
      await close_door()
    is_open = val

@export var direction: DoorLocation.Direction = DoorLocation.Direction.UP

@onready var teleport_target_marker_2d: Marker2D = $TeleportTargetMarker2D
@onready var open_doorway_sprite_2d: Sprite2D = %OpenDoorwaySprite2D
@onready var door_animated_sprite_2d: AnimatedSprite2D = %DoorAnimatedSprite2D
@onready var closed_door_static_body_2d: StaticBody2D = %ClosedDoorStaticBody2D
@onready var open_audio_stream_player_2d: AudioStreamPlayer2D = %OpenAudioStreamPlayer2D
@onready var close_audio_stream_player_2d: AudioStreamPlayer2D = %CloseAudioStreamPlayer2D



func _ready() -> void:
  body_entered.connect(_on_body_entered)
  if is_open:
      open_door(true)
  else:
      close_door(true)
  is_open = true
  

func teleport_to_target(body: Node2D):
  var translation: Vector2 = Vector2.ZERO
  match direction:
    DoorLocation.Direction.UP:
      translation = Vector2(0, -150)
    DoorLocation.Direction.RIGHT:
      translation = Vector2(218, 0)
    DoorLocation.Direction.DOWN:
      translation = Vector2(0, 150)
    DoorLocation.Direction.LEFT:
      translation = Vector2(-218, 0)
  #body.global_position = teleport_target_marker_2d.global_position
  body.global_position += translation
  

func _on_body_entered(body: PhysicsBody2D):
  if body is PlayerController:
    #body.global_position = teleport_target_marker_2d.global_position
    teleport_to_target(body)
    print("teleported")
  
func open_door(mute: bool = false):
  door_animated_sprite_2d.play("open")
  if not mute:
    open_audio_stream_player_2d.play()
  await door_animated_sprite_2d.animation_finished
  closed_door_static_body_2d.collision_layer = 0
  
func close_door(mute: bool = false):
  door_animated_sprite_2d.play("close")
  if not mute:
    close_audio_stream_player_2d.play()
  closed_door_static_body_2d.collision_layer = 8
  await door_animated_sprite_2d.animation_finished
