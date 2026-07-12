extends Node3D

var already_found: bool = false

var meshes: Array[MeshInstance3D] = [$Body, $Head, $Eye1, $Eye2]
@onready var effects: Array[Variant] = [$Fog, $GPUPurpleParticles3D]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass # Replace with function body.
	
func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		pass


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
