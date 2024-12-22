extends CollectableEffectResource

class_name HealEffectResource

@export var heal_value: float = 0
@export var percent_healed: float = 0.5

func apply_effect(recipient: CharacterBody2D):
    var health_component: HealthComponent = recipient.get("health_component")
    if health_component != null and health_component is HealthComponent:
        health_component.heal(heal_value)
        health_component.heal_percent(percent_healed)
