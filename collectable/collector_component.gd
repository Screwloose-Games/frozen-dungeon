extends Area2D

@export var recipient: CharacterBody2D
@onready var collected_label = %CollectedLabel

# Called when the node enters the scene tree for the first time.
func _ready():
    if recipient == null:
        recipient = get_parent()
    area_entered.connect(_on_area_entered)
    pass # Replace with function body.

func _on_area_entered(area: Area2D):
    if area.has_method("get_collected"):
        collect(area)

func collect(collectable: Collectable):
    collectable.get_collected(recipient)
    display_collected_text()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass

func display_collected_text():
    var collected_label = collected_label.duplicate()
    add_child(collected_label)
    collected_label.display()
