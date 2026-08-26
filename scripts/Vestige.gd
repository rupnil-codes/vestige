extends Node3D

var cutscene: bool = false

@onready var fps_counter: Label = $CanvasLayer/UserInterface/FPSCounter
@onready var subviewport: SubViewport = $SubViewport

@onready var dialogue_text: Label = %DialogueText

func _input(event):
	subviewport.push_input(event)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if cutscene:
		await get_tree().create_timer(2).timeout
		dialogue_text.typewrite("Good ..., explorer!")
		cutscene = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var fps: int = int(Engine.get_frames_per_second())
	fps_counter.text = "%d fps" % [fps]
