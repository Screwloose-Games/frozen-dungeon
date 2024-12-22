extends LineEdit

func _ready():
  text_changed.connect(_on_text_changed)
  text_submitted.connect(_on_text_submitted)
  focus_exited.connect(_on_focus_exited)

func _on_text_changed(new_text):
    var filtered_text = ""
    for char in new_text:
        if char in "0123456789":
            filtered_text += char
    
    text = filtered_text
    set_caret_column(text.length())

func _on_focus_exited():
    if text.strip_edges() == "" or not text.is_valid_int():
        text = "0"

func _on_text_submitted(new_text: String):
    if new_text.strip_edges() == "" or not new_text.is_valid_int():
        text = "0"
    else:
        text = str(int(new_text))
    
