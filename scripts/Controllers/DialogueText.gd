extends Label

@onready var dialogue_text: Label = %DialogueText
@onready var player_3d: CharacterBody3D = $"../../../SubViewport/Player3D"

var writing: bool = false
var timer: float = 3.0
var fast_mode_mult: float = 0.6

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func typewrite(sentence: String, fast_mode: bool = false, super_multiplier: float = 1.0, wait_timer: float = timer) -> void:
	var speed_multiplier: float = 1.0
	if fast_mode:
		speed_multiplier = fast_mode_mult * super_multiplier
	
	if not writing:
		player_3d.player_animation_player.play("type", -1, 1/speed_multiplier)
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

		player_3d.player_animation_player.stop()
		
		await get_tree().create_timer(wait_timer).timeout

		player_3d.player_animation_player.play("delete", -1, 1/speed_multiplier)
		
		await delete_char_by_char(fast_mode, super_multiplier)
		writing = false

		player_3d.player_animation_player.stop()
	
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
