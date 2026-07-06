extends Node3D

var silhouettes_found: int = 0
var waking_up: bool = true
const TOTAL_SILHOUETTES: int = 9

@onready var counter_label: Label = $"CanvasLayer/UserInterface/CounterLabel"
@onready var fps_counter: Label = $CanvasLayer/UserInterface/FPSCounter
@onready var subviewport: SubViewport = $SubViewport
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _input(event):
	subviewport.push_input(event)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for silhouette in $"SubViewport/World/Silhouettes".get_children():
		silhouette.silhouettes_found.connect(_on_silhouette_found)
	
	animation_player.play("wake_up")
	await animation_player.animation_finished
	waking_up = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var fps: int = int(Engine.get_frames_per_second())
	fps_counter.text = "%d fps" % [fps]
	
func _on_silhouette_found():
	silhouettes_found += 1
	if silhouettes_found == 1:
		animation_player.play("silhouette_counter")
	counter_label.text = "%d/%d found" % [silhouettes_found, TOTAL_SILHOUETTES]
	
	
