extends Node3D

@onready var vestige_map_2_animation_player: AnimationPlayer = $VestigeMap2AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func show_secondary_map_meshes() -> void:
	vestige_map_2_animation_player.play("show_secondary_map_meshes")
