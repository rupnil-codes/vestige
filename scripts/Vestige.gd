extends Node3D

var waking_up: bool = false

@onready var fps_counter: Label = $CanvasLayer/UserInterface/FPSCounter
@onready var subviewport: SubViewport = $SubViewport

func _input(event):
	subviewport.push_input(event)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var fps: int = int(Engine.get_frames_per_second())
	fps_counter.text = "%d fps" % [fps]
