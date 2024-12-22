extends Label

var timer: float = 0.0
var running: bool = false

@export var finish_area: FinishArea

var time_ms: int:
  get: return get_ms()

# get time in milliseconds
func get_ms() -> int:
    return int(floor(timer * 1000))

func _ready() -> void:
    text = "0:00:000"
    start()
    finish_area.player_finished.connect(_on_player_finished)

func _on_player_finished():
  stop()

func _process(delta: float) -> void:
    if running:
        timer += delta
        update_timer_display()

func update_timer_display() -> void:
    var minutes: int = int(timer) / 60
    var seconds: int = int(timer) % 60
    var milliseconds: int = int(timer * 1000) % 1000
    text = str(minutes) + ":" + str(seconds).pad_zeros(2) + ":" + str(milliseconds).pad_zeros(3)

func start() -> void:
    running = true

func stop() -> void:
    running = false
