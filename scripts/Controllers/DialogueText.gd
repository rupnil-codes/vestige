extends Label

@onready var dialogue_text: Label = %DialogueText
var writing: bool = false
var timer: int = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func typewrite(sentence: String) -> void:
	if not writing:
		writing = true
		for character in sentence:
			dialogue_text.text += character
			await get_tree().create_timer(0.06).timeout
		
		for i in range(timer):
			await get_tree().create_timer(1).timeout
	
		dialogue_text.text = ""
		writing = false
	
func write(sentence: String) -> void:
	if not writing:
		writing = true
		
		dialogue_text.text = sentence

		for i in range(timer):
			await get_tree().create_timer(1).timeout

		dialogue_text.text = ""
		writing = false
