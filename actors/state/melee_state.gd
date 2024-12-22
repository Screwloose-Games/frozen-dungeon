class_name MeleeState
extends State

var actor: Actor
var scene_tree: SceneTree
var target: Node2D
var animation_name: StringName

func _init(init_actor: Node2D, init_tree: SceneTree, init_animation_name: StringName):
    name = "MeleeState"
    actor = init_actor
    scene_tree = init_tree
    animation_name = init_animation_name

func set_target(new_target: Node2D):
    target = new_target

func enter():
    actor.animated_sprite.play(animation_name)
    actor.attack_animation_player.play(animation_name)
    if not actor.animated_sprite.animation_finished.is_connected(_on_animation_finished):
        actor.animated_sprite.animation_finished.connect(_on_animation_finished)

func _on_animation_finished():
    actor.state_completed.emit()

func exit():
    #actor.animated_sprite.stop()
    actor.attack_animation_player.stop()
    if actor.animated_sprite.animation_finished.is_connected(_on_animation_finished):
        actor.animated_sprite.animation_finished.disconnect(_on_animation_finished)

func update(delta):
    actor.velocity = Vector2.ZERO
