extends Node3D

@onready var flames: GPUParticles3D = $flamesGPU
@onready var light: OmniLight3D = $Light3D
@onready var bottom: MeshInstance3D = $Cube
@onready var top: MeshInstance3D = $Cube_001

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_visible_on_screen_notifier_3d_screen_entered() -> void:
	#var tween: Tween = create_tween()
	#tween.tween_callback(flames.show)
	flames.process_mode = Node.PROCESS_MODE_ALWAYS
	top.visible = true
	bottom.visible = true
	light.light_specular = 0.3

func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	#var tween: Tween = create_tween()
	#tween.tween_callback(flames.hide)
	flames.process_mode = Node.PROCESS_MODE_DISABLED
	top.visible = false
	bottom.visible = false
	light.light_specular = 0
