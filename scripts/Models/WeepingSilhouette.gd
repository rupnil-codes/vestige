extends Node3D

@onready var weeping_silhouette_animation_player: AnimationPlayer = $WeepingSilhouetteAnimationPlayer
@export var _weeping_silhouette_animation_done: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "Player3D":
		weeping_silhouette_animation_player.play("vanish")
		await weeping_silhouette_animation_player.animation_finished
		_weeping_silhouette_animation_done = true
