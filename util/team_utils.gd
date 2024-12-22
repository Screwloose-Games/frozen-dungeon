extends RefCounted
class_name TeamUtils

enum Team {
    PLAYER,
    ENEMY,
    UNALIGNED,
    PEACEFUL
}

static func get_hit_collision_mask(team: Team) -> CollisionLayer:
    match team:
        Team.PLAYER:
            return CollisionLayer.ENEMY_HURT
        Team.ENEMY:
            return CollisionLayer.PLAYER_HURT
        Team.UNALIGNED:
            return CollisionLayer.PLAYER_HURT + CollisionLayer.ENEMY_HURT
        Team.PEACEFUL:
            return CollisionLayer.NONE
    return CollisionLayer.NONE

static func get_hurt_collision_layer(team: Team) -> CollisionLayer:
    match team:
        Team.PLAYER:
            return CollisionLayer.PLAYER_HURT
        Team.ENEMY:
            return CollisionLayer.ENEMY_HURT
        Team.UNALIGNED:
            return CollisionLayer.PLAYER_HURT + CollisionLayer.ENEMY_HURT
        Team.PEACEFUL:
            return CollisionLayer.NONE
    return CollisionLayer.NONE

static func set_collisions(area: Area2D, team: Team):
    if area is HitBoxComponent:
        area.collision_mask = get_hit_collision_mask(team)
        area.collision_layer = 0
    elif area is HurtBoxComponent:
        area.collision_mask = 0
        area.collision_layer = get_hurt_collision_layer(team)

enum CollisionLayer {
    NONE = 0, # none
    PLAYER_COLLISION = 1, # (1)
    ENEMY_COLLISION = 2, # (2)
    PLAYER_CAMERA_TRACKER = 4, # (3)
    ENVIRONMENT_COLLISION = 8, # (2)
    COLLECTABLE = 16, # (5)
    ENEMY_HURT = 32, # (6)
    PLAYER_HURT = 64 # (7)
}
