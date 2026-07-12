extends Node3D

var already_found: bool = false
var visible_on_screen_enabler: bool = true

var meshes: Array[MeshInstance3D] = [$Body, $Head, $Eye1, $Eye2]
@onready var effects: Array[Variant] = [$Fog, $GPUPurpleParticles3D]
@onready var silhouette_animation_mover: AnimationPlayer = $"../../../SilhouetteAnimationMover"
@onready var silhouette_animation_player: AnimationPlayer = $SilhouetteAnimationPlayer
@onready var visible_on_screen_enabler_3d: VisibleOnScreenEnabler3D = $VisibleOnScreenEnabler3D

var movement: Array[String] = [
	"location_1",
	"location_2",
	"location_3"
]
var next_location_index: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass # Replace with function body.
	
func _on_area_3d_body_entered(body: Node3D) -> void:
	if visible_on_screen_enabler:
		visible_on_screen_enabler_3d.queue_free()
		visible_on_screen_enabler = false
	if body.is_in_group("player"):
		if next_location_index < len(movement):
			silhouette_animation_player.play("transform")
			await silhouette_animation_player.animation_finished
			silhouette_animation_mover.play(movement[next_location_index])
			await silhouette_animation_mover.animation_finished
			silhouette_animation_player.play_backwards("transform")
			await silhouette_animation_player.animation_finished
			next_location_index += 1
		


func fade_out(time: float = 2.0):
	$VisibleOnScreenEnabler3D.queue_free()
	visibility(effects, meshes, true)
	
	var tween: Tween = create_tween()
	
	for mesh in meshes:
		fade_mesh(mesh, tween, time)

	tween.parallel().tween_property($PurpleLight3D, "light_energy", 0.0, time)
	var fog_material: Resource = $Fog.material.duplicate()
	$Fog.material = fog_material

	tween.parallel().tween_property(
		fog_material,
		"density",
		0.0,
		time
	)
	
	tween.parallel().tween_property($GPUPurpleParticles3D, "transparency", 1.0, time)
	
	if $GPUDeathParticles3D:
		tween.tween_callback($GPUDeathParticles3D.set_emitting.bind(true))
		tween.tween_interval($GPUDeathParticles3D.lifetime)
	
	await tween.finished
	queue_free()
func fade_mesh(mesh: MeshInstance3D, tween: Tween, time: float = 2.0):
	tween.parallel().tween_property(mesh, "transparency", 1.0, time)


func _on_visible_on_screen_notifier_3d_screen_entered() -> void:
	#print("Entered")
	if not already_found:
		visibility(effects, meshes, true)

func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	#print("Exited")
	if not already_found:
		visibility(effects, meshes, false)
	
	
func visibility(nodes: Array[Variant], mesh_array: Array[MeshInstance3D], is_showing: bool) -> void:
	
	for node in nodes:
		#print(node.get_class())
		
		if node.get_class() == str(GPUParticles3D):
			if is_showing:
				node.process_mode = Node.PROCESS_MODE_ALWAYS
			else:
				node.process_mode = Node.PROCESS_MODE_DISABLED
			continue
		
		node.visible = is_showing
		
	for mesh in mesh_array:
		mesh.visible = is_showing
