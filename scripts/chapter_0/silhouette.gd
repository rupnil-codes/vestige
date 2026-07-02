extends Node3D

var already_found = false
signal silhouettes_found

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
	var meshes = [$Body, $Head, $Eye1, $Eye2]

	var tween = create_tween()
	
	for mesh in meshes:
		fade_mesh(mesh, tween)
	tween.parallel().tween_property($OmniLight3D, "light_energy", 0.0, 2.0)
	var fog_material = $FogVolume.material.duplicate()
	$FogVolume.material = fog_material

	tween.parallel().tween_property(
		fog_material,
		"density",
		0.0,
		2.0
	)
	
	await tween.finished
	queue_free()
func fade_mesh(mesh: MeshInstance3D, tween: Tween):
	tween.parallel().tween_property(mesh, "transparency", 1.0, 2.0)
