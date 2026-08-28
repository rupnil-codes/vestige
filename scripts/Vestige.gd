extends Node3D

@onready var fps_counter: Label = $CanvasLayer/UserInterface/FPSCounter
@onready var subviewport: SubViewport = $SubViewport

@onready var dialogue_text: Label = %DialogueText
@onready var vestige_scene_var: Node3D = %VestigeSceneVar

func _input(event):
	subviewport.push_input(event)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if vestige_scene_var.intro:
		await get_tree().create_timer(1).timeout
		await dialogue_text.typewrite("Greetings, wanderer!")
		vestige_scene_var.cutscene = false
		vestige_scene_var.intro = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var fps: int = int(Engine.get_frames_per_second())
	fps_counter.text = "%d fps" % [fps]
