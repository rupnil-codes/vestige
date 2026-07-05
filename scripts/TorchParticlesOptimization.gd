extends Node3D

@onready var flames: GPUParticles3D = $flamesGPU

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_visible_on_screen_notifier_3d_screen_entered() -> void:
	var tween: Tween = create_tween()
	tween.tween_callback(flames.show)

func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	var tween: Tween = create_tween()
	tween.tween_callback(flames.hide)
