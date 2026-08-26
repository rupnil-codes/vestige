extends Label

@onready var dialogue_text: Label = %DialogueText

var writing: bool = false
var timer: int = 3
var fast_mode_mult: float = 0.6

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func typewrite(sentence: String, fast_mode: bool = false, super_multiplier: float = 1.0) -> void:
	var speed_multiplier: float = 1.0
	if fast_mode:
		speed_multiplier = fast_mode_mult * super_multiplier
	
	if not writing:
		writing = true
		for character in sentence:
			if character == "⛚":
				await get_tree().create_timer(0.6 * speed_multiplier).timeout
			elif character in [".", ",", "!"]:
				dialogue_text.text += character
				await get_tree().create_timer(0.4 * speed_multiplier).timeout
			else:
				dialogue_text.text += character
				await get_tree().create_timer(0.1 * speed_multiplier).timeout
		
		for i in range(timer):
			await get_tree().create_timer(1).timeout

		await delete_char_by_char(fast_mode, super_multiplier)
		writing = false
func delete_char_by_char(fast_mode: bool = false, super_multiplier: float = 1.0) -> void:
	var speed_multiplier: float = 1
	if fast_mode:
		speed_multiplier = fast_mode_mult * super_multiplier
		
	while dialogue_text.text.length() > 0:
		dialogue_text.text = dialogue_text.text.left(-1)
		await get_tree().create_timer(0.06 * speed_multiplier).timeout
	
func write(sentence: String) -> void:
	if not writing:
		writing = true
		
		dialogue_text.text = sentence

		for i in range(timer):
			await get_tree().create_timer(1).timeout

		dialogue_text.text = ""
		writing = false
