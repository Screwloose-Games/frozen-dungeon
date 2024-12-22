extends Node

@export var dungeon_music: AudioStream

@onready var audio_stream_player: AudioStreamPlayer = %AudioStreamPlayer
@onready var audio_stream_player_2: AudioStreamPlayer = %AudioStreamPlayer2

func _ready() -> void:
  play(dungeon_music)
  pass

func play(stream: AudioStream):
  audio_stream_player.stream = stream
  audio_stream_player.play()
