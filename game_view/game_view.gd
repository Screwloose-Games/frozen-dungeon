extends Node2D

@export var transition_seconds: float = 1.0

var map_open: bool = false
var screen_height = 0

@onready var level: TextureRect = %Level
@onready var map: Control = %Map

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    screen_height = get_viewport().get_visible_rect().size.y
    # Start map off-screen (-y by screen_height pixels)
    map.position.y -= screen_height
    #level.position.y -= screen_height

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass

func show_map():
    if map_open:
        return
    map_open = true
    # Create tween to transition over transition_seconds
    var tween = get_tree().create_tween()
    tween.tween_property(map, "position", Vector2(0, 0), transition_seconds)
    tween.parallel()
    tween.tween_property(level, "position", Vector2(0, screen_height), transition_seconds)
    await tween.finished
    pass

func hide_map():
    if not map_open:
        return
    map_open = false
    # Create tween to transition over transition_seconds
    var tween = get_tree().create_tween()
    tween.tween_property(map, "position", Vector2(0, -screen_height), transition_seconds)
    tween.parallel()
    tween.tween_property(level, "position", Vector2(0, 0), transition_seconds)

func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("map"):
        if map_open:
            hide_map()
        else:
            show_map()
