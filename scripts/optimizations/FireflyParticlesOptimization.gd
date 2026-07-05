extends Node3D

@onready var fireflies: GPUParticles3D = $GPUFireflies3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_visible_on_screen_notifier_3d_screen_entered() -> void:
	fireflies.process_mode = Node.PROCESS_MODE_ALWAYS

func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	fireflies.process_mode = Node.PROCESS_MODE_DISABLED
