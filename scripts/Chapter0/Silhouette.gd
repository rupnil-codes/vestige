extends Node3D

var already_found = false
signal silhouettes_found

var meshes: Array[MeshInstance3D] = [$Body, $Head, $Eye1, $Eye2]
@onready var effects: Array[Variant] = [$PurpleLight3D, $Fog, $GPUPurpleParticles3D]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_3d_body_entered(body: Node3D) -> void:
	if already_found:
		return
		
	if body.is_in_group("player"):
		already_found = true
		silhouettes_found.emit()
		$Area3D.monitoring = false
		fade_out()
		
func fade_out():
	var tween: Tween = create_tween()
	
	for mesh in meshes:
		fade_mesh(mesh, tween)

	tween.parallel().tween_property($PurpleLight3D, "light_energy", 0.0, 2.0)
	var fog_material: Resource = $Fog.material.duplicate()
	$Fog.material = fog_material

	tween.parallel().tween_property(
		fog_material,
		"density",
		0.0,
		2.0
	)
	
	tween.parallel().tween_property($GPUPurpleParticles3D, "transparency", 1.0, 2.0)
	
	if $GPUDeathParticles3D:
		tween.tween_callback($GPUDeathParticles3D.set_emitting.bind(true))
		tween.tween_interval($GPUDeathParticles3D.lifetime)
	
	await tween.finished
	queue_free()
func fade_mesh(mesh: MeshInstance3D, tween: Tween):
	tween.parallel().tween_property(mesh, "transparency", 1.0, 2.0)


func _on_visible_on_screen_notifier_3d_screen_entered() -> void:
	#print("Entered")
	visibility(effects, true)

func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	#print("Exited")
	visibility(effects, false)
	
	
func visibility(nodes: Array[Variant], visible: bool) -> void:
	var tween: Tween = create_tween()
	
	for node in nodes:
		if visible:
			tween.tween_callback(node.show)
		else:
			tween.tween_callback(node.hide)
			
	await tween.finished
   
