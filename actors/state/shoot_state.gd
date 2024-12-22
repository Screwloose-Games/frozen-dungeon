class_name ShootState
extends State

var actor: Actor
var scene_tree: SceneTree
var target: Node2D
var ranged_weapon: RangedWeapon
var duration: float
var time_passed = 0.0

func _init(init_actor: Node2D, init_tree: SceneTree, init_ranged_weapon: RangedWeapon, init_duration: float):
    name = "ShootState"
    actor = init_actor
    scene_tree = init_tree
    ranged_weapon = init_ranged_weapon
    duration = init_duration

func set_target(new_target: Node2D):
    target = new_target

func enter():
    #actor.can_shoot = true
    time_passed = 0.0
    for i in range(duration):
        actor.animated_sprite.play("shoot")
        await scene_tree.create_timer(0.2).timeout
        ranged_weapon.fire_projectile()
        await actor.animated_sprite.animation_finished
        await scene_tree.create_timer(0.1).timeout
    actor.state_completed.emit()

func exit():
    #actor.can_shoot = false
    time_passed = 0.0
    pass


func update(delta):
    pass
    actor.velocity = Vector2.ZERO
    #time_passed += delta
    #if time_passed >= duration:
        #actor.state_completed.emit()
