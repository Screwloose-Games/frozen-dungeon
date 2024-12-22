extends CanvasLayer

@export var finish_area: FinishArea
@onready var overlay: ColorRect = $Overlay
@onready var finish = $Finish

var has_finished := false

func _ready() -> void:
  finish.pressed.connect(_on_finish_pressed)
  hide()
  finish_area.player_finished.connect(_on_player_finished)

func _on_player_finished():
  if not has_finished:
    has_finished = true
    show()
    await get_tree().create_timer(1).timeout
  
func _on_finish_pressed():
    finish.visible=false
    overlay.show()
    var input_score_scene = SceneManager.INPUT_SCORE.instantiate()
    var level_timer = get_tree().get_first_node_in_group("LevelTimer")
    input_score_scene.score = level_timer.time_ms
    add_child(input_score_scene)
