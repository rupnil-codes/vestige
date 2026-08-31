extends Node3D

@onready var fps_counter: Label = $CanvasLayer/UserInterface/FPSCounter
@onready var subviewport: SubViewport = $SubViewport

@onready var dialogue_text: Label = %DialogueText
@onready var vestige_scene_var: Node3D = %VestigeSceneVar

var intro_running: bool = false

func _input(event):
	subviewport.push_input(event)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if vestige_scene_var.intro and not intro_running:
		start_intro()
	
	var fps: int = int(Engine.get_frames_per_second())
	fps_counter.text = "%d fps" % [fps]


func start_intro() -> void:
	intro_running = true
	
	%VestigeAnimationPlayer.stop()
	%MainMenuSilhouette.visible = false

	await get_tree().create_timer(1.0).timeout
	
	await dialogue_text.typewrite("Greetings, wanderer!")
	
	vestige_scene_var.cutscene = false
	vestige_scene_var.intro = false
	
	intro_running = false
