extends Area2D

@export var camera: PhantomCamera2D

static var cameras: Array[PhantomCamera2D] = []

func _ready():
    cameras.append(camera)
    area_entered.connect(_on_area_entered)

func _on_area_entered(player):
    deprioritize_cameras()
    camera.priority = 10
    if camera.follow_mode != camera.FollowMode.NONE:
        camera.set_follow_target(player)
    #var per = get_tree().get_first_node_in_group("Player")
    #camera.follow_target = per

func deprioritize_cameras():
    for camera in cameras:
        camera.priority = 0
