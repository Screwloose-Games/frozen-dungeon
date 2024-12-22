extends ProgressBar

class_name HealthBarUI

@export var health_component : HealthComponent
@export var visible_when_full: bool = false

func _ready():
    if not is_instance_valid(health_component):
      health_component = get_tree().get_first_node_in_group("PlayerHealthComponent")
    assert(health_component != null)
    value = health_component.current_health
    max_value = health_component.max_health
    health_component.health_changed.connect(_on_health_changed)
    if !visible_when_full:
        if health_component.current_health == health_component.max_health:
            visible = false

func _on_health_changed(new_health: int):
    value = new_health
    if not health_component.current_health == health_component.max_health:
        visible = true

func _process(_delta):
    value = health_component.current_health

func _on_health_bar_area_entered(area):
    if area.has_method("pop"):
        area.pop()
